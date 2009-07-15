# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

KDE_MINIMAL="4.2"
#KDE_LINGUAS="ar be bg ca cs da de el es et eu fa fi fr ga gl he hi is it ja km
#ko lt lv lb nds ne nl nn pa pl pt pt_BR ro ru se sk sl sv th tr uk vi zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="A webcam application for KDE."
HOMEPAGE="http://code.google.com/p/webkam-kde4/"
SRC_URI="http://webkam-kde4.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="4"
IUSE=""

DEPEND="
	dev-lang/ruby
	>=media-libs/gstreamer-0.10
	x11-libs/qt-core[qt3support]
	x11-libs/qt-dbus
	x11-libs/qt-gui
"
