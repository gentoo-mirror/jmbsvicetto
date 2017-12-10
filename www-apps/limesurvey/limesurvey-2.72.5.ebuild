# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit webapp

MY_PN="LimeSurvey"
MY_DATE="171121"
MY_PV="${PV}+${MY_DATE}"

DESCRIPTION="LimeSurvey is a popular Free Open Source Software survey tool"
HOMEPAGE="https://www.limesurvey.org/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS=""
IUSE="+gd ldap mssql mysql postgres zip"
REQUIRED_USE="^^ ( mssql mysql postgres )"

DEPEND="
	app-admin/webapp-config
"
RDEPEND="
	dev-lang/php[gd?,hash,ldap?,session,zip?,zlib]
	mssql? ( dev-lang/php[mssql] )
	mysql? ( dev-lang/php[mysqli] )
	postgres? ( dev-lang/php[postgres] )
"
S="${WORKDIR}/${MY_PN}-${PV}-${MY_DATE}"

pkg_config () {

	webapp_pkg_setup
}

src_install () {

	webapp_src_preinst

	einfo "Installing files"
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_src_install
}

pkg_preinst () {

	fowners -R root:apache "${MY_HTDOCSDIR}"
	fperms -R g-w,o-rwx "${MY_HTDOCSDIR}"

	# Allow writing to the tmp, upload and application/config directories
	for dir in tmp upload application/config ; do

		fperms -R g+w "${MY_HTDOCSDIR}/${dir}"
	done
}
