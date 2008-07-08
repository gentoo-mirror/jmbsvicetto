# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit cmake-utils

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="http://www.kde.org"
SRC_URI="ftp://ftp.kde.org/pub/kde/unstable/4.0.83/support/${PN/-server/}-${PV}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="4.1"
KEYWORDS="~amd64"
IUSE="mysql"

RDEPEND="!app-office/akonadi
	>=x11-libs/qt-core-4.4.0_rc1:4
	>=x11-libs/qt-dbus-4.4.0_rc1:4
	x11-misc/shared-mime-info
	mysql? ( virtual/mysql )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	kde-base/automoc"

MY_PN="${PN/-server/}-${PV}"
S="${WORKDIR}/$MY_PN"

src_unpack() {
	unpack ${A}

	# Don't check for mysql, avoid an automagic dep.
	if ! use mysql; then
		sed -e '/mysqld/s/find_program/#DONOTWANT &/' \
			-i "${S}"/server/CMakeLists.txt || die 'Sed failed.'
	fi
}
