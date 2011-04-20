# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp

DESCRIPTION="GLPI is the Information Resource-Manager with an additional Administration- Interface."
HOMEPAGE="http://www.glpi-project.org/"
SRC_URI="https://forge.indepnet.net/attachments/download/597/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-admin/webapp-config
"
RDEPEND="
	dev-db/mysql
	dev-lang/php
"
S="${WORKDIR}/${PN}"

src_install() {

	webapp_src_preinst

	einfo "Installing files"
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
