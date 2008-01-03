# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

S=${WORKDIR}/${PN} # Adjust path...

DESCRIPTION="A taskbar replacement for compositing WM's (like compiz/beryl)"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=49484"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/49484-${PN}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="mirror"
IUSE=""
SLOT="0"

need-kde 3.5

pkg_postinst() {
	kde_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
