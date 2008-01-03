# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

NEED_PYTHON="2.3"

inherit multilib python

DESCRIPTION="Python bindings to Clutter"
HOMEPAGE="http://www.clutter-project.org/"
SRC_URI="http://www.clutter-project.org/sources/${PN}/${PV/.2/}/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo gstreamer gtk"
RESTRICT="mirror"

DEPEND=">=dev-python/pygobject-2.12.1
	>=media-libs/clutter-0.4
	gtk? ( dev-libs/atk
		>=dev-python/pygtk-2.10
		>=media-libs/clutter-gtk-0.4 )
	gstreamer? ( >=dev-python/gst-python-0.10
		>=media-libs/clutter-gst-0.4 )
	cairo? ( >=dev-python/pycairo-1.4
		>=media-libs/clutter-cairo-0.4 )"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS ChangeLog

	insinto /usr/share/doc/${PF}/examples
	doins examples/*.{py,png}
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages/gtk-2.0
}
