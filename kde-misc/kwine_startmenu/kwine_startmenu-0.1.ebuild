# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="KDE Wine Startmenu Entries"
HOMEPAGE="http://kwine.sourceforge.net/"
SRC_URI="mirror://sourceforge/kwine/kwine_startmenu-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=">=kde-misc/kwinetools-0.1
		|| ( kde-base/kdebase kde-base/kdebase-meta )
		>=kde-misc/kwinedcop-0.1"
RDEPEND="${DEPEND}"

need-kde 3.4

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gcc-4.1.patch
}
