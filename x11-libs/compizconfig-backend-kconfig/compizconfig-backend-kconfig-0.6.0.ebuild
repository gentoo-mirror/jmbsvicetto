# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

COMPIZ_RELEASE=0.6.2

DESCRIPTION="Compizconfig Kconfig Backend"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="~x11-wm/compiz-${COMPIZ_RELEASE}
	~x11-libs/libcompizconfig-${PV}"

need-kde 3.5

pkg_postinst() {
	kde_pkg_postinst
	echo

	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org/"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
