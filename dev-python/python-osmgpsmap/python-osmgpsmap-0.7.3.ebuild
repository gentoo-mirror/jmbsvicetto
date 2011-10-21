# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools distutils

DESCRIPTION="osm-gps-map python bindings."
HOMEPAGE="http://nzjrs.github.com/osm-gps-map/"
SRC_URI="http://www.johnstowers.co.nz/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sci-geosciences/osm-gps-map
"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
