# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

MODULE_AUTHOR=SIXTEASE
MODULE_VERSION="1.0000"

inherit perl-module

DESCRIPTION="Mapping of XML entities to Unicode"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="virtual/perl-Module-Build
	test? ( virtual/perl-Test-Simple )
"
RDEPEND="dev-perl/HTML-Parser"

S="${WORKDIR}/${PN}"

SRC_TEST="do"
