# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/lib/konq
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The embeddable part of konqueror"
KEYWORDS="~amd64"
IUSE="debug"
RESTRICT="test"
PATCHES="${FILESDIR}/fix_includes_install.patch"
KMSAVELIBS="true"