# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_PN="Nagibot"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-v${PV}.tar.gz"
DESCRIPTION="Perl extension that uses XMPP for nagios notifications"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icinga"

RDEPEND="
	dev-perl/yaml
	dev-perl/AnyEvent
	dev-perl/AnyEvent-XMPP
	dev-perl/Nagios-Status-HostStatus
	dev-perl/Nagios-Status-ServiceStatus
	virtual/perl-Text-ParseWords
	dev-perl/Sys-CpuLoad
	dev-perl/File-Pid
	icinga? ( net-analyzer/icinga )
	!icinga? ( net-analyzer/nagios )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-v${PV}"
SRC_TEST="do"

src_prepare() {
	sed -i -e "s:!/opt/perl/bin/perl:!/usr/bin/perl:" nagibot.pl

	cp "${FILESDIR}/nagibot.conf" "${S}"
	if ( use icinga ); then
		sed -i -e "s:prefix=nagios:prefix=icinga:" nagibot.conf
	fi
}

src_install() {
	dobin nagibot.pl
	newinitd "${FILESDIR}/nagibot.init" nagibot
	doconfd "nagibot.conf"

	dodoc INSTALL README TODO Changes nagios-misccommands nagibot-example.conf
}
