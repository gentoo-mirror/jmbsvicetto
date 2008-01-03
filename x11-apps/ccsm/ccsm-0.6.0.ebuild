# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2-utils

COMPIZCONFIG_PYTHON_RELEASE=0.6.0.1

DESCRIPTION="Compizconfig Settings Manager"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI="http://releases.compiz-fusion.org/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="~dev-python/compizconfig-python-${COMPIZCONFIG_PYTHON_RELEASE}
	>=dev-python/pygtk-2.10"

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
