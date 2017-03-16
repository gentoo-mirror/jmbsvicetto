# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RCROWDER
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Nagios 3.0 Class to maintain Hosts' Status"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Nagios-Status-Host"
DEPEND="${RDEPEND}"

SRC_TEST="do"
