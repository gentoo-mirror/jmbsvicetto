# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit horde-v2

DESCRIPTION="Horde Application Framework"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE="mysql"

DEPEND=""
RDEPEND="dev-lang/php[session,xml]
	>=dev-libs/libxml2-2.4.21
	dev-php/PEAR-Log
	dev-php/PEAR-Mail_Mime
	>=sys-devel/gettext-0.10.40
	>=www-apps/horde-pear-1.3
	mysql? ( dev-php/PEAR-DB )"

src_unpack() {
	horde-v2_src_unpack
	cd "${S}"
	chmod 600 scripts/sql/create.*.sql #137510
}

pkg_postinst() {
	horde-v2_pkg_postinst
	elog "Horde requires PHP to have:"
	elog "    ==> 'short_open_tag enabled = On'"
	elog "    ==> 'magic_quotes_runtime set = Off'"
	elog "    ==> 'file_uploads enabled = On'"
}