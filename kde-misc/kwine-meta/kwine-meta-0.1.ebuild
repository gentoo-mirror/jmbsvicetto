# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="KDE Wine - Meta Package"
HOMEPAGE="http://kwine.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"
DEPEND=">=kde-misc/kwinetools-0.1
		>=kde-misc/kio-wine-0.1
		>=kde-misc/kwine-0.1
		>=kde-misc/kwinedcop-0.1
		>=kde-misc/kfile_wine-0.1
		>=kde-misc/kwine_startmenu-0.1"
RDEPEND="${DEPEND}"
