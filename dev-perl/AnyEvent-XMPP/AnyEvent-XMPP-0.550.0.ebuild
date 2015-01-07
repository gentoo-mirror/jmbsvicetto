# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=MSTPLBG
MODULE_VERSION=0.55
inherit perl-module

DESCRIPTION="An implementation of the XMPP Protocol"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/Object-Event
	dev-perl/XML-Writer
	dev-perl/XML-Parser
	virtual/perl-MIME-Base64
	dev-perl/Authen-SASL
	dev-perl/Net-LibIDN
	virtual/perl-Digest-SHA
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
