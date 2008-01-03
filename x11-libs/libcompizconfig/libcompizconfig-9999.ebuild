# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git autotools

EGIT_REPO_URI="git://anongit.compiz-fusion.org/fusion/compizconfig/${PN}"

DESCRIPTION="Compiz Configuration System (git)"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="~x11-wm/compiz-${PV}
	dev-libs/libxml2"
DEPEND=">=dev-util/pkgconfig-0.19"

S="${WORKDIR}/${PN}"

src_compile() {
	eautoreconf || die "eautoreconf failed"
	glib-gettextize --copy --force || die "glib-gettextize failed"
	intltoolize --copy --force || die "intltoolize failed"

	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org/"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
