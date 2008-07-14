# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/${PN}
inherit kde4-meta

DESCRIPTION="A KDE filemanager focusing on usability"
KEYWORDS="~amd64"
IUSE="debug htmlhandbook +semantic-desktop"

DEPEND=">=kde-base/libkonq-${PV}:${SLOT}
	semantic-desktop? ( kde-base/kdelibs:${SLOT}[semantic-desktop]
						>=kde-base/nepomuk-${PV}:${SLOT}
						>=dev-libs/soprano-2.0.7 )
	!semantic-desktop? ( kde-base/kdelibs:${SLOT}[-semantic-desktop] )"
RDEPEND="${DEPEND}"

KMEXTRA="apps/doc/${PN}"
KMLOADLIBS="libkonq"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)"
	kde4-meta_src_compile
}
