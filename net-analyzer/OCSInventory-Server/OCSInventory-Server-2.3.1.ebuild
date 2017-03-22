# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator

MY_PV_MAJOR="$(get_version_component_range 1-2 ${PV})"
MY_PV="${PV//[_]/}"
MY_PV="${MY_PV//rc/RC}"
MY_P="${PN}-${MY_PV}"
MY_PN="OCSInventory-NG"
MY_LPN="ocsinventory-server"

DESCRIPTION="OCS Inventory NG Management Server"
HOMEPAGE="http://www.ocsinventory-ng.org/"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${MY_PV}/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64"
IUSE="soap"

S="${WORKDIR}/${MY_P}"

DEPEND="
	dev-lang/perl
	sys-devel/make
"
RDEPEND="${DEPEND}
	!net-analyzer/ocsng[comm]
	app-admin/logrotate
	dev-perl/Apache-DBI
	dev-perl/Archive-Zip
	dev-perl/DBI
	dev-perl/DBD-mysql
	dev-perl/Net-IP
	dev-perl/XML-Simple
	virtual/perl-Compress-Raw-Zlib
	www-apache/mod_perl
	www-servers/apache
	soap? (
		dev-perl/SOAP-Lite
	)
"

src_compile() {

	pushd "Apache"
	perl Makefile.PL || die "perl Makefile.PL failed"
	emake || die "emake failed"
	popd
}

src_install() {

	LOGDIR="/var/log/ocsng"

	# Communication server
	PLUGINS_CONFIG_DIR="/usr/share/ocsng/config"
	PLUGINS_PERL_DIR="/usr/share/ocsng/plugins"

	pushd "Apache"
	emake DESTDIR="${D}" install || die "Install failed"
	popd

	insinto "/etc/logrotate.d"
	doins "${FILESDIR}/ocsng"

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

	# create log dir
	elog "Creating log dir"
	dodir "${LOGDIR}"

	dodoc "${FILESDIR}/postinstall-en.txt"
}

pkg_preinst () {

	# Fix dir permissions
	for dir in ${PLUGINS_CONFIG_DIR} ${PLUGINS_PERL_DIR} ; do
		fowners -R root:apache "${dir}"
		fperms g+w,o-rwx "${dir}"
	done

	fowners root:apache "${LOGDIR}"
	fperms ug+rwx,o-rwx "${LOGDIR}"
}

pkg_postinst () {

	elog "If you want to run ocsng in this system make sure to install a compatible MySQL DB."
}
