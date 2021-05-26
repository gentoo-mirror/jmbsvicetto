# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="Nagibot"
MY_PV="v${PV}"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="Perl extension that uses XMPP for nagios notifications"
HOMEPAGE="https://github.com/ajobs/NagiBot"
SRC_URI="https://github.com/ajobs/${MY_PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/AnyEvent-XMPP
	dev-perl/File-Pid
	dev-perl/Nagios-Status-HostStatus
	dev-perl/Nagios-Status-ServiceStatus
	dev-perl/Sys-CpuLoad
	dev-perl/YAML
	virtual/perl-Text-ParseWords
	|| (
		net-analyzer/icinga2
		net-analyzer/nagios
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-v${PV}"
SRC_TEST="do"

src_prepare() {
	sed -i -e "s:!/opt/perl/bin/perl:!/usr/bin/perl:" nagibot.pl

	cp "${FILESDIR}/nagibot.conf" "${S}"
	cp "${FILESDIR}/nagibot.cfg" "${S}"
	sed -i -e "s:PREFIX:nagios:" nagibot.cfg
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
