# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="KDE Wine DCOP"
HOMEPAGE="http://kwine.sourceforge.net/"
SRC_URI="mirror://sourceforge/kwine/kwinedcop-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"
DEPEND="kde-base/kdelibs
		app-emulation/wine"
RDEPEND="${DEPEND}"

src_compile() {
	econf --with-extra-includes=/usr/include/wine/windows || die
	emake || die
}

need-kde 3.4
