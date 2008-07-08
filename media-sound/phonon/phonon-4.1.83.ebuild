# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils

DESCRIPTION="KDE multimedia API"
KEYWORDS="~amd64"
IUSE="debug gstreamer"
SRC_URI="mirror://kde/unstable/4.0.83/support//${P}.tar.bz2"
SLOT="0"

LICENSE="GPL-2"

RDEPEND="!kde-base/phonon:kde-svn
	>=x11-libs/qt-dbus-4.4.0:4
	>=x11-libs/qt-gui-4.4.0:4
	gstreamer? ( media-libs/gstreamer
		media-libs/gst-plugins-base )"
DEPEND="${RDEPEND}
	kde-base/automoc"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with gstreamer GStreamer)
		$(cmake-utils_use_with gstreamer GStreamerPlugins)"
	cmake-utils_src_compile
}
