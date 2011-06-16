# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools gnome2

DESCRIPTION="osm-gps-map is a gtk+ viewer for OpenStreetMap files."
HOMEPAGE="http://nzjrs.github.com/osm-gps-map/"
SRC_URI="http://www.johnstowers.co.nz/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="introspection python"

DEPEND="
	>=dev-libs/glib-2.16.0
	>=net-libs/libsoup-2.4.0
	>=x11-libs/cairo-1.6.0
	>=x11-libs/gtk+-2.14.0
	python? ( dev-python/pygtk )
"
RDEPEND="${DEPEND}"

G2CONF="
	$(use_enable introspection)
	--docdir=/usr/share/doc/${PN}
	--disable-dependency-tracking
	--enable-fast-install
	--disable-static
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-docs-location.patch"
	eautoreconf

	gnome2_src_prepare
}
