# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="XFCE4 Macmenu Plugin"
HOMEPAGE="http://aquila.deus.googlepages.com"
SRC_URI="http://distfiles.gentoo-xeffects.org/${PN}/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.8.20-r1
	>=xfce-base/xfce4-panel-4.4
	x11-libs/libwnck"

pkg_setup() {
	if ! built_with_use x11-libs/gtk+ macmenu ; then
		elog "Please rebuild x11-libs/gtk+ with USE=\"macmenu\""
		die "Please rebuild x11-libs/gtk+ with USE=\"macmenu\""
	fi
}

src_unpack() {
	unpack "${A}"

	cd "${S}"
	epatch "${FILESDIR}"/${PN}-location.patch
}

src_compile() {
	cd "${S}"
	gcc -std=c99 -Wall -Werror -fno-strict-aliasing -DFOR_XFCE `pkg-config --cflags --libs libwnck-1.0 libxfce4panel-1.0` ${CFLAGS} ${LDFLAGS} -o xfce4-macmenu-plugin macmenu-applet.c || die "make failed"
}

src_install() {
	exeinto /usr/lib/xfce4/panel-plugins
	doexe xfce4-macmenu-plugin
	insinto /usr/share/xfce4/panel-plugins
	doins xfce4-macmenu-plugin.desktop
}
