# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

MY_PV_MAJOR="$(ver_cut 1-2 ${PV})"
MY_PV="${PV//[_]/}"
MY_PV="${MY_PV//rc/RC}"
MY_PN="OCSInventory-NG"
MY_LPN="ocsinventory-server"

DESCRIPTION="OCS Inventory NG Management Server"
HOMEPAGE="http://www.ocsinventory-ng.org/"
SRC_URI="https://github.com/${MY_PN}/${PN}/archive/${MY_PV}/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64"
IUSE="soap"

DEPEND=""
RDEPEND="${DEPEND}
	!net-analyzer/ocsng[admin]
	dev-lang/php[mysqli,xml]
"

src_install() {

	LOGDIR="/var/log/ocsng"

	# Administration server
	ADM_STATIC_DIR="/usr/share/ocsng/reports"
	ADM_VAR_DIR="/var/lib/ocsng"
	IPD_DIR="ipd"
	PACKAGES_DIR="download"
	SNMP_DIR="snmp"

	# Create ocsreports dirs
	elog "Creating ${D}/${ADM_STATIC_DIR} dir"
	dodir "${ADM_STATIC_DIR}" || die "Unable to create ${ADM_STATIC_DIR}"

	# copy ocsreports
	insinto "${ADM_STATIC_DIR}"
	doins -r *

	# Create dirs (/var)
	elog "Creating ${ADM_VAR_DIR}/{${IPD_DIR},${PACKAGES_DIR},${SNMP_DIR}} dirs"
	for dir in ${IPD_DIR} ${PACKAGES_DIR} ${SNMP_DIR} ; do
		dodir "${ADM_VAR_DIR}/${dir}" || die "Unable to create ${ADM_VAR_DIR}/${dir}"
	done
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
