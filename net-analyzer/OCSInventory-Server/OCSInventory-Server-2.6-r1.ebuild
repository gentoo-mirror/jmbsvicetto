# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils perl-module

MY_PV_MAJOR="$(ver_cut 1-2 ${PV})"
MY_PV="${PV//[_]/}"
MY_PV="${MY_PV//rc/RC}"
MY_P="${PN}-${MY_PV}"
MY_PN="OCSInventory-NG"
MY_LPN="ocsinventory-server"

DESCRIPTION="OCS Inventory NG Management Server"
HOMEPAGE="http://www.ocsinventory-ng.org/"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64"
IUSE="rest soap"

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
	rest? (
		dev-perl/Mojolicious
		dev-perl/Plack
		dev-perl/Switch
	)
"

src_configure() {
	pushd Apache || die
	perl-module_src_configure
	popd || die
}

src_compile() {

	pushd Apache || die
	perl-module_src_compile
	popd || die
}

src_install() {

	LOGDIR="/var/log/ocsng"

	# Communication server
	PLUGINS_CONFIG_DIR="/usr/share/ocsng/config"
	PLUGINS_PERL_DIR="/usr/share/ocsng/plugins"

	pushd Apache || die
	perl-module_src_install
	popd || die

	insinto "/etc/logrotate.d"
	doins "${FILESDIR}/ocsng"

	# Configure OCS (communication server)
	# set mod_perl version > 1.999_21
	sed -i -e "s/VERSION_MP/2/" etc/ocsinventory/ocsinventory-server.conf
	sed -i -e "s:PATH_TO_LOG_DIRECTORY:${LOGDIR}:" etc/ocsinventory/ocsinventory-server.conf
	sed -i -e "s:PATH_TO_PLUGINS_CONFIG_DIRECTORY:${PLUGINS_CONFIG_DIR}:" etc/ocsinventory/ocsinventory-server.conf
	sed -i -e "s:PATH_TO_PLUGINS_PERL_DIRECTORY:${PLUGINS_PERL_DIR}:" etc/ocsinventory/ocsinventory-server.conf
	dodoc "etc/ocsinventory/ocsinventory-server.conf"

	ADM_STATIC_DIR="/usr/share/ocsng/reports"
	ADM_REPORTS_ALIAS="/ocsreports"
	ADM_VAR_DIR="/var/lib/ocsng"
	IPD_DIR="ipd"
	IPD_ALIAS="/ipd"
	PACKAGES_DIR="download"
	PACKAGES_ALIAS="/download"
	SNMP_DIR="snmp"
	SNMP_ALIAS="/snmp"

	# OCSREPORTS example config
	sed -i -e "s:OCSREPORTS_ALIAS:${ADM_REPORTS_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:PATH_TO_OCSREPORTS_DIR:${ADM_STATIC_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:IPD_ALIAS:${IPD_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:PATH_TO_IPD_DIR:${IPD_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:PACKAGES_ALIAS:${PACKAGES_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:PATH_TO_PACKAGES_DIR:${PACKAGES_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:SNMP_ALIAS:${SNMP_ALIAS}:" etc/ocsinventory/ocsinventory-reports.conf
	sed -i -e "s:PATH_TO_SNMP_DIR:${SNMP_DIR}:" etc/ocsinventory/ocsinventory-reports.conf
	dodoc "etc/ocsinventory/ocsinventory-reports.conf"

	REST_API_DIR="$(perl -e "print \"@INC[-1]\"")"

	# OCSRESTAPI example config
	sed -i -e "s:REST_API_PATH:${REST_API_DIR}:" etc/ocsinventory/ocsinventory-restapi.conf
	sed -i -e "s:REST_API_LOADER_PATH:${REST_API_DIR}/Api/Ocsinventory/Restapi/Loader.pm:" etc/ocsinventory/ocsinventory-restapi.conf
	dodoc "etc/ocsinventory/ocsinventory-restapi.conf"

	# Create dirs
	for dir in ${PLUGINS_CONFIG_DIR} ${PLUGINS_PERL_DIR} ; do
		dodir "${dir}" || die "Unable to create ${dir}"
	done

	# create log dir
	elog "Creating log dir"
	dodir "${LOGDIR}"

	dodoc "${FILESDIR}/postinstall-en.txt"

	keepdir /var/log/ocsng
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
