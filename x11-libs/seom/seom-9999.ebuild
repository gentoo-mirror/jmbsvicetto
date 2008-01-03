# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

ESVN_REPO_URI="svn://neopsis.com/big/svn/seom/trunk"

DESCRIPTION="seom video capturing library"
HOMEPAGE="http://neopsis.com/projects/seom"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="x11-base/xorg-server
	>=dev-lang/yasm-0.5"

S="${WORKDIR}/trunk"

src_install() {
	sed -i -e "s|svn info|svn info ${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}|g" seom.pc.in || die "sed failed"
	make DESTDIR="${D}" install || die "make installed failed"
}

pkg_postinst() {
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
