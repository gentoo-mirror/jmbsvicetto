# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gnome-python-desktop/gnome-python-desktop-2.18.0.ebuild,v 1.11 2007/08/28 19:41:16 jer Exp $

inherit gnome2 python virtualx

DESCRIPTION="provides python interfacing modules for some GNOME desktop libraries"
HOMEPAGE="http://pygtk.org/"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc nognome rsvg wnck"

#
# nognome is set to not require extra packages which require gnome.
# only useful when you explicitly set wnck and/or rsvg
#

RDEPEND="virtual/python
	>=dev-python/pygtk-2.10.3
	>=dev-libs/glib-2.6.0
	>=x11-libs/gtk+-2.4.0
	dev-python/pycairo
	!nognome? ( >=dev-python/gnome-python-2.10.0
		>=gnome-base/gnome-panel-2.13.4
		>=gnome-base/libgnomeprint-2.2.0
		>=gnome-base/libgnomeprintui-2.2.0
		>=x11-libs/gtksourceview-1.1.90
		>=gnome-base/libgtop-2.13.0
		>=gnome-extra/nautilus-cd-burner-2.15.3
		>=gnome-extra/gnome-media-2.10.0
		>=gnome-base/gconf-2.10.0
		>=x11-wm/metacity-2.17.5
		media-video/totem
		>=gnome-base/gnome-keyring-0.5.0
		>=gnome-base/gnome-desktop-2.10.0
		>=x11-libs/libwnck-2.15.5
		>=gnome-base/librsvg-2.13.93
	)
	wnck? ( >=x11-libs/libwnck-2.15.5 )
	rsvg? ( >=gnome-base/librsvg-2.13.93 )
	!<dev-python/gnome-python-extras-2.13"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.7"

DOCS="AUTHORS ChangeLog INSTALL MAINTAINERS NEWS README"

src_test() {
	Xmake check || die "tests failed"
}

src_install() {
	gnome2_src_install

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}"/usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0

	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org/"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}

pkg_postrm() {
	python_version
	python_mod_cleanup
}
