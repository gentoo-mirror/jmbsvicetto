# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="Control Center module for editing your ~/.kde/Autostart entries"
HOMEPAGE="http://beta.smileaf.org/"
SRC_URI="http://beta.smileaf.org/files/autostart/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="mirror"
IUSE=""
SLOT="0"

need-kde 3.4

src_install() {

	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README

}

pkg_postinst() {
	kde_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
