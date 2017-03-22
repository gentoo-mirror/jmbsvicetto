# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator

MY_PV_MAJOR="$(get_version_component_range 1-2 ${PV})"
MY_PV="${PV//[_]/}"
MY_PV="${MY_PV//rc/RC}"
MY_P="OCSNG_UNIX_SERVER-${MY_PV}"
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

DEPEND=""
RDEPEND="${DEPEND}
	!net-analyzer/ocsng[admin]
	dev-lang/php[mysqli,xml]
"

src_install() {

	LOGDIR="/var/log/ocsng"

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
}

pkg_preinst () {

	# Fix dir permissions
	# Protect the db config file and ocsreports
	fowners -R root:apache "${ADM_STATIC_DIR}"
	fperms -R g-w,o-rwx "${ADM_STATIC_DIR}"

	if [[ -f "${D}/${ADM_STATIC_DIR}/dbconfig.inc.php" ]] ; then
		fperms g+w,o-rwx "${ADM_STATIC_DIR}/dbconfig.inc.php"
	fi

	for dir in ${IPD_DIR} ${PACKAGES_DIR} ${SNMP_DIR} ; do
		fowners -R apache:apache "${ADM_VAR_DIR}/${dir}"
		fperms g-w,o-rwx "${ADM_VAR_DIR}/${dir}"
	done

	fowners root:apache  "${ADM_STATIC_DIR}/ipdiscover-util.pl"
	fperms ug+x,o-rwx "${ADM_STATIC_DIR}/ipdiscover-util.pl"
}
