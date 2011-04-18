# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

MODULE_AUTHOR=SIXTEASE

inherit perl-module

DESCRIPTION="Mapping of XML entities to Unicode"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build"
RDEPEND="${DEPEND}
	dev-perl/HTML-Parser
"

S="${WORKDIR}/${PN}"
