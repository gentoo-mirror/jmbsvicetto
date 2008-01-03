# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Screenlets are small owner-drawn applications"
HOMEPAGE="http://www.screenlets.org"
SRC_URI="http://ryxperience.com/storage/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyxdg
	dev-python/dbus-python
	x11-libs/libnotify
	>=dev-python/gnome-python-desktop-2.16.0
	x11-misc/notification-daemon
	x11-misc/xdg-utils"

RDEPEND="${DEPEND}"

src_install() {
	sed -i "s;/usr/local;/usr;g" \
		src/lib/__init__.py \
		setup.py bin/screenlets-* \
		desktop-menu/applications/* \
		desktop-menu/desktop-directories/Screenlets.directory || die "sed failed to change install path"

		python setup.py install --root "${D}" || die "installation failed"

	insinto /usr/share/desktop-directories
	doins "${S}"/desktop-menu/desktop-directories/Screenlets.directory

	insinto /usr/share/icons
	doins "${S}"/desktop-menu/screenlets.svg

	# Insert .desktop files
	insinto /usr/share/applications
	cd "${S}"/desktop-menu
	for x in $(find -name "${S}"/desktop-menu '*.desktop')
	do
		doins $x
	done
}

pkg_postinst() {
	desktop_files="CPUMeterScreenlet.desktop ClockScreenlet.desktop
		ControlScreenlet.desktop FlowerScreenlet.desktop
		LauncherScreenlet.desktop MailCheckScreenlet.desktop
		NotesScreenlet.desktop PicframeScreenlet.desktop
		RulerScreenlet.desktop WindowlistScreenlet.desktop"

	for x in $desktop_files
	do
		xdg-desktop-menu install --novendor /usr/share/desktop-directories/Screenlets.directory \
			/usr/share/applications/$x
	done
}

pkg_postrm() {
	desktop_files="CPUMeterScreenlet.desktop ClockScreenlet.desktop
		ControlScreenlet.desktop FlowerScreenlet.desktop
		LauncherScreenlet.desktop MailCheckScreenlet.desktop
		NotesScreenlet.desktop PicframeScreenlet.desktop
		RulerScreenlet.desktop WindowlistScreenlet.desktop"

	for x in $desktop_files
	do
		xdg-desktop-menu uninstall /usr/share/desktop-directories/Screenlets.directory \
			/usr/share/applications/$x
	done
}
