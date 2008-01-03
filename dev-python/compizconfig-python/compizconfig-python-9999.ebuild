# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git autotools

EGIT_REPO_URI="git://anongit.compiz-fusion.org/fusion/compizconfig/${PN}"

DESCRIPTION="Compizconfig Python Bindings (git)"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="~x11-wm/compiz-${PV}
	~x11-libs/libcompizconfig-${PV}
	>=dev-libs/glib-2.6
	|| ( >=dev-lang/python-2.4 >=dev-lang/python-2.5 )
	dev-python/pyrex"

S="${WORKDIR}/${PN}"

src_compile() {
	eautoreconf || die "eautoreconf failed"

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
