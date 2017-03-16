# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CWEST
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Pid File Manipulation"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Class-Accessor"
DEPEND="${RDEPEND}"

SRC_TEST="do"
