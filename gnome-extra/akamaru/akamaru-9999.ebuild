# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 subversion autotools eutils

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}/"

S="${WORKDIR}/${PN}"

DESCRIPTION="Simple, but fun, physics engine prototype."
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-libs/glib-2.8"

src_compile() {
	eautoreconf
	gnome2_src_compile
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
