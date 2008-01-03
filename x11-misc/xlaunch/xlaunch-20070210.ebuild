# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

DESCRIPTION="Bash script to launch programs on different displays."
HOMEPAGE="http://forums.gentoo.org/viewtopic-t-483004.html"
SRC_URI="http://distfiles.gentoo-xeffects.org/xlaunch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="x11-base/xorg-server"
DEPEND=""

src_install() {
	dobin xlaunch
}

pkg_postinst() {
	ewarn
	ewarn "Use this script at your own risk."
	ewarn "Visit http://forums.gentoo.org/viewtopic-p-3467798.html for more details."
	ewarn
}
