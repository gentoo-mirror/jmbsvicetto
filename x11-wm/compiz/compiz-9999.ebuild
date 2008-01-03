# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/compiz/compiz-0.5.0.ebuild,v 1.1 2007/04/24 01:51:02 hanno Exp $

inherit autotools git

EGIT_REPO_URI="git://anongit.freedesktop.org/git/xorg/app/compiz"

DESCRIPTION="3D composite- and windowmanager"
HOMEPAGE="http://www.compiz.org/"
SRC_URI=""

LICENSE="GPL-2 LGPL-2.1 MIT"
SLOT="0"
KEYWORDS=""
IUSE="xcb dbus gnome kde svg fuse gtk"

DEPEND=">=media-libs/mesa-6.5.1-r1
	>=media-libs/glitz-0.5.6
	>=x11-base/xorg-server-1.1.1-r1
	x11-libs/libXdamage
	x11-libs/libXrandr
	x11-libs/libXcomposite
	x11-libs/libXinerama
	x11-proto/damageproto
	media-libs/libpng
	x11-libs/libxcb
	>=x11-libs/gtk+-2.0
	x11-libs/startup-notification
	gnome-base/gconf
	gnome? ( >=x11-libs/libwnck-2.16.1
		>=gnome-base/control-center-2.16.1 )
	svg? ( gnome-base/librsvg )
	dbus? ( >=sys-apps/dbus-1.0 )
	kde? (
		|| ( kde-base/kdebase kde-base/kwin )
		dev-libs/dbus-qt3-old )
	fuse? ( sys-fs/fuse )"

RDEPEND="${DEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo"

pkg_setup() {
	if use xcb && ! built_with_use "x11-libs/libX11" "xcb" ; then
		eerror "Compiz now requires libX11 to be built with xcb."
		eerror "Please build libX11 with USE=\"xcb\""
		ewarn "Be warned that building libX11 with xcb support will break Java."
		die "Build libX11 with USE=\"xcb\""
	fi
}

src_compile() {

	if ! use xcb; then
		epatch "${FILESDIR}"/${PN}-drop-xcb.patch
	fi

	eautoreconf || die "eautoreconf failed"
	intltoolize --copy --force || die "intltoolize failed"
	glib-gettextize --copy --force || die "glib-gettextize failed"

	# Temporarily removed $(use_enable gnome)
	# It breaks building

	econf \
		--with-default-plugins \
		$(use_enable gtk) \
		$(use_enable gnome gconf) \
		$(use_enable gnome) \
		$(use_enable gnome metacity) \
		$(use_enable kde) \
		$(use_enable svg librsvg) \
		$(use_enable dbus) \
		$(use_enable dbus dbus-glib) \
		$(use_enable fuse) || die

	make || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# Install compiz-manager
	dobin "${FILESDIR}/compiz-manager" || die "dobin failed"

	# Create gentoo's config file
	dodir /etc/xdg/compiz

	cat <<- EOF > "${D}/etc/xdg/compiz/compiz-manager"
COMPIZ_BIN_PATH="/usr/bin/"
PLUGIN_PATH="/usr/$(get_libdir)/compiz/"
LIBGL_NVIDIA="/usr/$(get_libdir)/opengl/xorg-x11/libGL.so.1.2"
LIBGL_FGLRX="/usr/$(get_libdir)/opengl/xorg-x11/libGL.so.1.2"
KWIN="`type -p kwin`"
METACITY="`type -p metacity`"
SKIP_CHECKS="yes"
EOF

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"
}
