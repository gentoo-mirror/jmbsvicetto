# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 bzr autotools

EBZR_REPO_URI="http://bazaar.launchpad.net/~awn-core/awn/"

DESCRIPTION="Avant Window Navgator (Awn) is a dock-like bar which sits at the bottom of the screen (in all its composited-goodness) tracking open windows."
HOMEPAGE="http://code.google.com/p/avant-window-navigator/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-libs/glib-2.8.0
	dev-python/gnome-python
	dev-python/gnome-python-desktop
	gnome-base/gconf
	gnome-base/gnome-desktop
	gnome-base/libgnome
	gnome-base/gnome-vfs
	x11-libs/gtk+
	x11-libs/libwnck"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_compile() {
	./autogen.sh --prefix=/usr --sysconfdir=/etc
	gnome2_src_compile
}

pkg_postinst() {
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
