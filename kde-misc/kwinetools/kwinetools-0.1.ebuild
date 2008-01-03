# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="KDE Wine tools"
HOMEPAGE="http://kwine.sourceforge.net/"
SRC_URI="mirror://sourceforge/kwine/kwinetools-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"
DEPEND="kde-base/kdelibs
		>=app-emulation/wine-0.9.1"
RDEPEND="${DEPEND}"

need-kde 3.4
