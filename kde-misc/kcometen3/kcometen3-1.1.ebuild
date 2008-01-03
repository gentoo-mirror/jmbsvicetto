# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="3D OpenGL screen saver for KDE"
HOMEPAGE="http://user.cs.tu-berlin.de/~pmueller/"
SRC_URI="http://user.cs.tu-berlin.de/~pmueller/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"
RESTRICT="mirror"

need-kde 3.4
