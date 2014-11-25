# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit depend.php eutils versionator

MY_PV_MAJOR="$(get_version_component_range 1-2 ${PV})"
MY_PV="${PV//[_]/}"
MY_P="OCSNG_UNIX_SERVER-${MY_PV}"
MY_LPN="ocsinventory-server"

DESCRIPTION="OCS Inventory NG Management Server"
HOMEPAGE="http://ocsinventory.sourceforge.net/"
SRC_URI="http://launchpad.net/${MY_LPN}/stable-${MY_PV_MAJOR}/${MY_PV}/+download/${MY_P}.tar.gz"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64"
IUSE="+comm admin logrotate soap"

S="${WORKDIR}/${MY_P}"

DEPEND="
	dev-lang/perl
	comm? ( sys-devel/make )
"
RDEPEND="${DEPEND}
	>=dev-perl/Apache-DBI-0.93
	>=dev-perl/DBI-1.40
	>=dev-perl/DBD-mysql-2.9004
	>=dev-perl/Net-IP-1.21
	>=dev-perl/XML-Simple-2.12
	virtual/perl-Compress-Raw-Zlib
	www-apache/mod_perl
	>=www-servers/apache-1.3
	admin? ( dev-lang/php[mysqli,xml] )
	logrotate? ( app-admin/logrotate )
	soap? (
		dev-perl/SOAP-Lite
	)
"
REQUIRED_USE="|| ( admin comm )"

src_compile() {

	if ( use comm ); then

		pushd "Apache"
		perl Makefile.PL || die "perl Makefile.PL failed"
		emake || die "emake failed"
		popd
	fi
}

src_install() {

	LOGDIR="/var/log/ocsng"

	# Communication server
	PLUGINS_CONFIG_DIR="/usr/share/ocsng/config"
	PLUGINS_PERL_DIR="/usr/share/ocsng/plugins"

	# Administration server
	ADM_STATIC_DIR="/usr/share/ocsng/reports"
	ADM_REPORTS_ALIAS="/ocsreports"
	ADM_VAR_DIR="/var/lib/ocsng"
	IPD_DIR="ipd"
	IPD_ALIAS="/ipd"
	PACKAGES_DIR="download"
	PACKAGES_ALIAS="/download"
	SNMP_DIR="snmp"
	SNMP_ALIAS="/snmp"

	if ( use comm ); then

		pushd "Apache"
		emake DESTDIR="${D}" install || die "Install failed"
		popd

		if use logrotate; then

			insinto "/etc/logrotate.d"
			doins "${FILESDIR}/ocsng"
		fi

		# Configure OCS (communication server)
		# set mod_perl version > 1.999_21
		sed -i -e "s/VERSION_MP/2/" etc/ocsinventory/ocsinventory-server.conf
		sed -i -e "s:PATH_TO_LOG_DIRECTORY:${LOGDIR}:" etc/ocsinventory/ocsinventory-server.conf
		sed -i -e "s:PATH_TO_PLUGINS_CONFIG_DIRECTORY:${PLUGINS_CONFIG_DIR}:" etc/ocsinventory/ocsinventory-server.conf
		sed -i -e "s:PATH_TO_PLUGINS_PERL_DIRECTORY:${PLUGINS_PERL_DIR}:" etc/ocsinventory/ocsinventory-server.conf

		dodoc "etc/ocsinventory/ocsinventory-server.conf"

		# Create dirs
		for dir in ${PLUGINS_CONFIG_DIR} ${PLUGINS_PERL_DIR} ; do
			dodir "${dir}" || die "Unable to create ${dir}"
		done

	fi

	if ( use admin ); then

		# Create ocsreports dirs
		elog "Creating ${D}/${ADM_STATIC_DIR} dir"
		dodir "${ADM_STATIC_DIR}" || die "Unable to create ${ADM_STATIC_DIR}"

		# copy ocsreports
		insinto "${ADM_STATIC_DIR}"
		doins -r ocsreports/*

		# Create dirs (/var)
		elog "Creating ${ADM_VAR_DIR}/{${IPD_DIR},${PACKAGES_DIR},${SNMP_DIR}} dirs"
		for dir in ${IPD_DIR} ${PACKAGES_DIR} ${SNMP_DIR} ; do
			dodir "${ADM_VAR_DIR}/${dir}" || die "Unable to create ${ADM_VAR_DIR}/${dir}"
		done

		# install ipdiscover-util.pl script
		elog "Install ipdiscover-util.pl script"
		insinto "${ADM_STATIC_DIR}"
		doins binutils/ipdiscover-util.pl

		# Configure OCS (Administration server)
		sed -i -e "s:OCSREPORTS_ALIAS:${ADM_REPORTS_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:PATH_TO_OCSREPORTS_DIR:${ADM_STATIC_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:IPD_ALIAS:${IPD_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:PATH_TO_IPD_DIR:${IPD_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:PACKAGES_ALIAS:${PACKAGES_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:PATH_TO_PACKAGES_DIR:${PACKAGES_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:SNMP_ALIAS:${SNMP_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
		sed -i -e "s:PATH_TO_SNMP_DIR:${SNMP_DIR}:" etc/ocsinventory/ocsinventory-reports.conf

		dodoc "etc/ocsinventory/ocsinventory-reports.conf"

	fi

	# create log dir
	elog "Creating log dir"
	dodir "${LOGDIR}"

	dodoc "${FILESDIR}/postinstall-en.txt"
}

pkg_preinst () {

	# Fix dir permissions
	if ( use comm ); then
		for dir in ${PLUGINS_CONFIG_DIR} ${PLUGINS_PERL_DIR} ; do
			fowners -R root:apache "${dir}"
			fperms g+w,o-rwx "${dir}"
		done
	fi

	if ( use admin ); then

		# Protect the db config file and ocsreports
		fowners -R root:apache "${ADM_STATIC_DIR}"
		fperms -R g-w,o-rwx "${ADM_STATIC_DIR}"

		if [[ -f "${ADM_STATIC_DIR}/dbconfig.inc.php" ]] ; then
			fperms g+w,o-rwx "${ADM_STATIC_DIR}/dbconfig.inc.php"
		fi

		for dir in ${IPD_DIR} ${PACKAGES_DIR} ${SNMP_DIR} ; do
			fowners -R apache:apache "${ADM_VAR_DIR}/${dir}"
			fperms g-w,o-rwx "${ADM_VAR_DIR}/${dir}"
		done

		fowners root:apache  "${ADM_STATIC_DIR}/ipdiscover-util.pl"
		fperms ug+x,o-rwx "${ADM_STATIC_DIR}/ipdiscover-util.pl"
	fi

	fowners root:apache "${LOGDIR}"
	fperms ug+rwx,o-rwx "${LOGDIR}"
}

pkg_postinst () {

	elog "If you want to run ocsng in this system make sure to install"
	elog "at least mysql-4.1."
}
