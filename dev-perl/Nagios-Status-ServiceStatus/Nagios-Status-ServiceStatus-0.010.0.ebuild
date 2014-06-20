# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR=RCROWDER
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Nagios 3.0 Class to maintain Services' Status"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Nagios-Status-Service"
DEPEND="${RDEPEND}"

SRC_TEST="do"