# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

NAME=${PN/-/_} # kio-resources va kio_resources
S=${WORKDIR}/${NAME}-${PV} # Adjust path...

DESCRIPTION="A KIO slave which provides the "resources" protocol for KDE."
HOMEPAGE="http://www.kde-look.org/content/show.php?content=26521"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/26521-${NAME}-${PV}.tar.bz2"

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
