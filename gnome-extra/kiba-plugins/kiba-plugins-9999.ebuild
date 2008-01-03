# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 subversion autotools eutils

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}"

S="${WORKDIR}/${PN/-/}"

DESCRIPTION="Kiba Dock Plugins"
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="glitz svg"

DEPEND="gnome-extra/kiba-dock
	gnome-base/gnome-vfs
	gnome-base/libgtop
	svg? ( gnome-base/librsvg )
	glitz? ( >=media-libs/glitz-0.4 )"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable glitz) $(use_enable svg)"
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
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
