# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/${PN}
inherit kde4-meta

DESCRIPTION="KDialog can be used to show nice dialog boxes from shell scripts"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}
	kernel_linux? (
		|| ( >=sys-apps/eject-2.1.5
			sys-block/unieject ) )"
