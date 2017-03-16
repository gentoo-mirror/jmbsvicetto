# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit webapp

MY_PN="LimeSurvey"
MY_DATE="161202"
MY_PV="${PV}+${MY_DATE}"

DESCRIPTION="LimeSurvey is a popular Free Open Source Software survey tool"
HOMEPAGE="https://www.limesurvey.org/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
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

	webapp_serverowned -R "${MY_HTDOCSDIR}/tmp"
	webapp_serverowned -R "${MY_HTDOCSDIR}/upload"
	webapp_serverowned -R "${MY_HTDOCSDIR}/application/config"

	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}

pkg_postinst () {
	echo
	ewarn "SECURITY NOTICE"
	ewarn "If you plan on using SSL on your Drupal site, please consult the postinstall information:"
	ewarn "\t# webapp-config --show-postinst ${PN} ${PV}"
	echo
	ewarn "If this is a new install, unless you want anyone with network access to your server to be"
	ewarn "able to run the setup, you'll have to configure your web server to limit access to it."
	echo
	ewarn "If you're doing a new drupal-8 install, you'll have to copy /sites/default/default.services.yml"
	ewarn "to /sites/default/services.yml and grant it write permissions to your web server."
	ewarn "Just follow the instructions of the drupal setup and be sure to resolve any permissions issue"
	ewarn "reported by the setup."
	echo
}
