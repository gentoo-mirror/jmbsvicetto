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
	dev-perl/AnyEvent
	dev-perl/AnyEvent-XMPP
	dev-perl/File-Pid
	dev-perl/Nagios-Status-HostStatus
	dev-perl/Nagios-Status-ServiceStatus
	dev-perl/Sys-CpuLoad
	dev-perl/yaml
	virtual/perl-Text-ParseWords
	icinga? ( net-analyzer/icinga )
	!icinga? ( net-analyzer/nagios )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-v${PV}"
SRC_TEST="do"

src_prepare() {
	sed -i -e "s:!/opt/perl/bin/perl:!/usr/bin/perl:" nagibot.pl

	cp "${FILESDIR}/nagibot.conf" "${S}"
	cp "${FILESDIR}/nagibot.cfg" "${S}"
	if ( use icinga ); then
		sed -i -e "s:PREFIX=nagios:PREFIX=icinga:" nagibot.conf

		sed -i -e "s:PREFIX:icinga:" nagibot.cfg
	else
		sed -i -e "s:PREFIX:nagios:" nagibot.cfg
	fi
}

src_install() {
	dobin nagibot.pl
	newinitd "${FILESDIR}/nagibot.init" nagibot
	newconfd "nagibot.conf" nagibot
	dodir /etc/nagibot
	insinto /etc/nagibot
	doins nagibot.cfg

	dodoc INSTALL README TODO Changes nagios-misccommands nagibot-example.conf
}

pkg_postinst() {
	ewarn "Please check /etc/conf.d/nagibot.conf and /etc/nagibot/nagibot.cfg"
	ewarn "as you need to set a few variables. Don't forget to set JID, configure"
	ewarn "the rooms and the ids to notify and set the password for the JID."
}
