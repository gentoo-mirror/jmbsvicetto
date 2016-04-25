# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit webapp

DESCRIPTION="GLPI is the Information Resource-Manager with an additional Administration- Interface."
HOMEPAGE="http://www.glpi-project.org/"
SRC_URI="https://forge.indepnet.net/attachments/download/2020/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-admin/webapp-config
"
RDEPEND="
	dev-lang/php
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

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}

pkg_preinst () {

	fowners -R root:apache "${MY_HTDOCSDIR}"
	fperms -R g-w,o-rwx "${MY_HTDOCSDIR}"

	# Allow writing to the config and files directories
	for dir in config files ; do

		fperms -R g+w "${MY_HTDOCSDIR}/${dir}"
	done
}
