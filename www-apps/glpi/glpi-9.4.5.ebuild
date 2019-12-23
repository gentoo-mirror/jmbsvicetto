# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit webapp

MY_PN="glpi-project"
MY_P=${P/_/-}
MY_PV=${PV/_/-}

DESCRIPTION="The Information Resource-Manager with an additional Administration Interface."
HOMEPAGE="http://www.glpi-project.org/"
SRC_URI="https://github.com/${MY_PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tgz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-admin/webapp-config
"
RDEPEND="
	dev-lang/php[curl,json,mysqli,session,unicode]
	virtual/mysql
"
S="${WORKDIR}/${PN}"

pkg_config () {

	webapp_pkg_setup
}

src_install () {

	webapp_src_preinst

	einfo "Installing files"
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	# Protect config files
	webapp_configfile "${MY_HTDOCSDIR}/".htaccess

	# Allow writing to the config and files directories
	for dir in config files .htaccess ; do

		webapp_serverowned -R "${MY_HTDOCSDIR}/${dir}"
	done

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
