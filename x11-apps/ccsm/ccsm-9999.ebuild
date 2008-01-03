# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git gnome2-utils

EGIT_REPO_URI="git://anongit.compiz-fusion.org/fusion/compizconfig/${PN}"

DESCRIPTION="Compizconfig Settings Manager (git)"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="~dev-python/compizconfig-python-${PV}
	>=dev-python/pygtk-2.10"

S="${WORKDIR}/${PN}"

src_compile() {
	cd "${S}"
	./setup.py build --prefix=/usr
}

src_install() {
	./setup.py install --root="${D}" --prefix=/usr
}

pkg_postinst() {
	if use gtk ; then gnome2_icon_cache_update ; fi

	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org/"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
