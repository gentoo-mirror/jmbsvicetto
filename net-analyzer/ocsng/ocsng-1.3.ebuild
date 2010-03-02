# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit depend.php eutils webapp

MY_P="OCSNG_UNIX_SERVER-${PV}"
MY_LPN="ocsinventory-server"
MY_HTDOCSDIR="/usr/share/webapps/${PN}/"
WEBAPP_MANUAL_SLOT="yes"

DESCRIPTION="OCS Inventory NG Management Server"
HOMEPAGE="http://ocsinventory.sourceforge.net/"
SRC_URI="http://launchpad.net/${MY_LPN}/stable-${PV}/server-release-${PV}/+download/${MY_P}.tar.gz"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64"
IUSE="+comm admin logrotate"

# INSTALL_DIR is used by webapp.eclass when USE=-vhosts
INSTALL_DIR="ocsng"
S="${WORKDIR}/${MY_P}"
LOGDIR="/var/log/ocsng"

DEPEND="
	comm? ( sys-devel/make )
	app-admin/webapp-config
"

RDEPEND="${DEPEND}
	dev-lang/perl
	>=dev-perl/Apache-DBI-0.93
	>=dev-perl/DBI-1.40
	>=dev-perl/DBD-mysql-2.9004
	>=dev-perl/XML-Simple-2.12
	>=dev-perl/Net-IP-1.21
	www-apache/mod_perl
	>=www-servers/apache-1.3
	admin? (
		virtual/php
	)
	logrotate? ( app-admin/logrotate )
"

pkg_setup() {

	# call default eclass pkg_setup
	webapp_pkg_setup

	# php must be built with mysql and xml support
	require_php_with_use mysql xml

	if ! ( use admin || use comm ); then

		# Warn user we will install the comm server
		elog "As you haven't specified any role for the server, we will install"
		elog "the communication server for ocs-ng."
		elog "If you don't want this role or want other roles, set the corresponding"
		elog "admin or comm use flags."
	fi
}

src_compile() {

	if ( use comm || ! ( use admin || use comm )); then

		pushd "Apache"
		perl Makefile.PL || die "perl Makefile.PL failed"
		emake || die "emake failed"
		popd
	fi
}

src_install() {

	# call default eclass src_preinst
	webapp_src_preinst

	fowners root:apache "${MY_HTDOCSDIR}"
	fperms g-w,o-rwx "${MY_HTDOCSDIR}"

	if ( use comm || ! ( use admin || use comm )); then

		pushd "Apache"
		emake DESTDIR="${D}" install || die "Install failed"
		popd

		if use logrotate; then

			# create logrotate config file
			elog "Create logrotate config file"

			dodir /etc/logrotate.d
			cat <<- EOF > "${D}etc/logrotate.d/ocsng"
				# Copyright 1999-2010 Gentoo Foundation
				# Distributed under the terms of the GNU General Public License v2
				# $Header: $
				#
				# OCSNG logrotate config for Gentoo Linux
				# Contributed by Jorge Manuel B. S. Vicetto (jmbsvicetto) jmbsvicetto@gentoo.org
				# Based on the original ocsng logrotate file by Didier LIROULET

				/var/log/ocsng/*.log {
				daily
				# rotate 7
				compress
				create 0660 root apache
				notifyempty
				missingok
				# postrotate
				# /etc/init.d/apache2 reload > /dev/null 2>&1 || true
				# endscript
				}
			EOF
		fi

		# set mod_perl version > 1.999_21
		sed -i -e "s/VERSION_MP/2/" etc/ocsinventory/ocsinventory-server.conf
		sed -i -e "s:PATH_TO_LOG_DIRECTORY:${LOGDIR}:" etc/ocsinventory/ocsinventory-server.conf

		# install the communication
		webapp_server_configfile apache "etc/ocsinventory/ocsinventory-server.conf"

	fi

	if use admin; then

		# create ocsreports and download dirs and copy files
		elog "Creating ${MY_HTDOCSDIR}/download and copying files"
		dodir "${MY_HTDOCSDIR}/download" || die "Unable to create ${MY_HTDOCSDIR}/download"
		insinto "${MY_HTDOCSDIR}"
		doins -r ocsreports
		dodir "${MY_HTDOCSDIR}/ocsreports/ipd" || die "Unable to create ${MY_HTDOCSDIR}/ocsreports/ipd"

		webapp_serverowned -R "${MY_HTDOCSDIR}/download"
		webapp_serverowned -R "${MY_HTDOCSDIR}/ocsreports"

		# set ownership and permissions
		elog "Set ownership of download and ocsreports"
		fowners -R root:apache "${MY_HTDOCSDIR}/download"
		fperms -R g-w,o-rwx "${MY_HTDOCSDIR}/download"
		fperms g+w "${MY_HTDOCSDIR}/download"
		fowners -R root:apache "${MY_HTDOCSDIR}/ocsreports"
		fperms -R g-w,o-rwx "${MY_HTDOCSDIR}/ocsreports"
		if [[ -f "${MY_HTDOCSDIR}/ocsreports/dbconfig.inc.php" ]] ; then
			fperms g-w,o-rwx "${MY_HTDOCSDIR}/ocsreports/dbconfig.inc.php"
		fi
		fperms -R g+w "${MY_HTDOCSDIR}/ocsreports/ipd"

		# install ipdiscover-util.pl script
		elog "Install ipdiscover-util.pl script"
		insinto "${MY_HTDOCSDIR}/ocsreports"
		doins binutils/ipdiscover-util.pl

		fowners root:apache  "${MY_HTDOCSDIR}/ocsreports/ipdiscover-util.pl"
		fperms ug+x "${MY_HTDOCSDIR}/ocsreports/ipdiscover-util.pl"

		webapp_server_configfile apache "etc/ocsinventory/ocsinventory-reports.conf"
	fi

	# create log dir
	elog "Creating log dir"
	dodir "${LOGDIR}"
	fowners root:apache "${LOGDIR}"
	fperms 770 "${LOGDIR}"

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	# call default eclass src_install
	webapp_src_install
}

pkg_postinst () {

	elog "If you want to run ocsng in this box make sure to install"
	elog "at least mysql-4.1."

	webapp_pkg_postinst
}
