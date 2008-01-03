# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 bzr autotools

EBZR_REPO_URI="http://bazaar.launchpad.net/~awn-extras/awn-extras/"

DESCRIPTION="Awn-extras provides applets for the Awn application"
HOMEPAGE="http://code.google.com/p/avant-window-navigator/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="gnome-extra/avant-window-navigator
	>=x11-libs/gtk+-2.0
	>=gnome-base/gnome-desktop-2.0
	>=gnome-base/librsvg-2.0
	gnome-base/gnome-menus"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_compile() {

	for dir in `find "${S}"/awn-* -mindepth 1 -type d`;
	do
		cd "${dir}"
		./autogen.sh --prefix=/usr --sysconfdir=/etc
		gnome2_src_compile
		cd "${S}"
	done
}

src_install() {
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"

	for dir in `find "${S}"/awn-* -mindepth 1 -type d`;
	do
		cd "${dir}"
		emake DESTDIR="${D}" install || die "make install of ${x} failed"
		cd "${S}"
	done
}

pkg_postinst() {
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
	einfo "If you want plugins for awn they can be downloaded at"
	einfo "http://codebrowse.launchpad.net/~awn-extras/awn-extras/trunk/files/"
}
