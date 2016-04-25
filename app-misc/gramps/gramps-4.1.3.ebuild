# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

#DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1

MY_PV=${PV/_/}

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
HOMEPAGE="http://www.gramps.org/"
SRC_URI="mirror://sourceforge/gramps/Stable/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geography +gexiv2 html +reports spell"

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	dev-python/bsddb3
	>=dev-python/pygobject-3.2.2-r1:3[${PYTHON_USEDEP}]
	dev-python/pyicu
	gnome-base/librsvg:2
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango[introspection]
	x11-misc/xdg-utils
	geography? ( >=sci-geosciences/osm-gps-map-1.0 )
	gexiv2? ( >=media-libs/gexiv2-0.5[${PYTHON_USEDEP},introspection] )
	html? ( net-libs/webkit-gtk:3[introspection]
	reports? ( media-gfx/graphviz )
	spell? (
		dev-python/gtkspell-python
		app-text/gtkspell[introspection]
	)
)"

S=${WORKDIR}/${PN}-${MY_PV}
DOCS="RELEASE_NOTES FAQ AUTHORS TODO NEWS README ChangeLog"

src_prepare() {
	epatch "${FILESDIR}/${PN}-resourcepath.patch"
#	epatch "${FILESDIR}/${P}-python-doc-init.patch"
#	epatch "${FILESDIR}/${P}-print-guiplug-error.patch"
	epatch "${FILESDIR}/${PN}-use_bsddb3.patch"
	distutils-r1_src_prepare
}
