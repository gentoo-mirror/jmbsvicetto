# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/vte/vte-0.14.1.ebuild,v 1.6 2006/12/21 13:19:56 corsair Exp $

inherit eutils gnome2 autotools

DESCRIPTION="Xft powered terminal widget"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc pcre python opengl"

RDEPEND=">=dev-libs/glib-2.9
	>=x11-libs/gtk+-2.6
	>=x11-libs/pango-1.1
	>=media-libs/freetype-2.0.2
	media-libs/fontconfig
	sys-libs/ncurses
	opengl? (
				virtual/opengl
				virtual/glu
			)
	pcre? ( dev-libs/libpcre )
	python? (
				>=dev-python/pygtk-2.4
				>=dev-lang/python-2.2
			)
	|| ( x11-libs/libX11 virtual/x11 )
	virtual/xft"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-1.0 )
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.9
	sys-devel/gettext"

DOCS="AUTHORS ChangeLog HACKING NEWS README"

pkg_setup() {
	G2CONF="$(use_enable debug debugging) $(use_enable python) \
			$(use_with opengl glX) $(use_with pcre) --with-xft2 --with-pangox"
}

src_unpack() {
	gnome2_src_unpack

	epatch "${FILESDIR}"/${PN}-0.13.2-no-lazy-bindings.patch
	epatch "${FILESDIR}"/${PN}-0.16.0-fix-transparency.patch

	cd "${S}"/gnome-pty-helper
	eautomake
}
