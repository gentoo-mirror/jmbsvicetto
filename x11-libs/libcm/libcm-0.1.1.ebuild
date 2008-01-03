# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/0.1/${P}.tar.bz2"

DESCRIPTION="Composite management library"
HOMEPAGE="http://www.gnome.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/glib
	x11-libs/libXxf86vm
	x11-libs/libXcomposite
	x11-libs/libXdamage
	>=media-libs/mesa-6.5.1"

pkg_setup() {
	# Build against xorg-x11 opengl
	elog "Setting opengl to xorg-x11 for proper build"
	opengl=$(eselect opengl show)
	eselect opengl set xorg-x11
}

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	# Reset back to old opengl
	elog "Setting opengl back to original setting"
	eselect opengl set $opengl
}
