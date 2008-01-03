# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde git

EGIT_REPO_URI="git://anongit.compiz-fusion.org/fusion/compizconfig/${PN}"

DESCRIPTION="Compizconfig Kconfig Backend (git)"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="~x11-wm/compiz-${PV}
	~x11-libs/libcompizconfig-${PV}"

S="${WORKDIR}/${PN}"

need-kde 3.5

pkg_postinst() {
	kde_pkg_postinst
	echo

	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org/"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
