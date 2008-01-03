# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git gnome2-utils

EGIT_REPO_URI="git://anongit.compiz-fusion.org/users/crdlb/${PN}"
COMPIZ_RELEASE=0.6.2
COMPIZCONFIG_PYTHON_RELEASE=0.6.0.1

DESCRIPTION="Compiz Fusion Tray Icon and Manager (git)"
HOMEPAGE="http://compiz-fusion.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk qt4"

RDEPEND="|| ( ~x11-wm/compiz-${PV} ~x11-wm/compiz-${COMPIZ_RELEASE} )
	|| ( ~dev-python/compizconfig-python-${PV} =dev-python/compizconfig-python-${COMPIZCONFIG_PYTHON_RELEASE} )
	gtk? ( >=dev-python/pygtk-2.10 )
	qt4? ( dev-python/PyQt4 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.19
	x11-apps/xvinfo"

S="${WORKDIR}/${PN}"

src_install() {
	if use gtk ; then interfaces="${interfaces} gtk" ; fi
	if use qt4 ; then interfaces="${interfaces} qt4" ; fi
	make "interfaces=${interfaces}" DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	if use gtk ; then gnome2_icon_cache_update ; fi

	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.org/"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
