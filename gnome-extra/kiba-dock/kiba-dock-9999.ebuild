# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 subversion autotools eutils

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}"

S="${WORKDIR}/${PN/-/}"

DESCRIPTION="Funny dock with support for the akamaru physics engine"
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="akamaru glitz svg"

PDEPEND="gnome-extra/kiba-plugins"

DEPEND=">=x11-libs/gtk+-2.8
	>=dev-libs/glib-2.8
	>=x11-libs/pango-1.10
	>=gnome-base/gnome-desktop-2.8
	svg? ( gnome-base/librsvg )
	glitz? ( >=media-libs/glitz-0.4 )
	akamaru? ( gnome-extra/akamaru )
	dev-libs/libxml2"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable glitz) $(use_enable svg) $(use_enable akamaru)"

	if use svg && ! built_with_use x11-libs/cairo svg ; then
		eerror "Please rebuild cairo with USE=\"svg\""
		die "rebuild cairo with USE=\"svg\""
	fi
}

src_compile() {
	eautoreconf || die "eautoreconf failed"
	intltoolize --force --copy || die "intltoolize failed"

	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	ewarn
	ewarn "If you have an ati card, you should disable the glitz support"
	ewarn "in kiba-dock and kiba-plugins. That should prevent a segmentation"
	ewarn "fault when starting kiba-dock."
	ewarn
	einfo "To add launchers, run /usr/bin/populate-dock.sh"
	einfo "or drag shortcuts (from gnome-menu for example) onto the dock"
	ewarn
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
