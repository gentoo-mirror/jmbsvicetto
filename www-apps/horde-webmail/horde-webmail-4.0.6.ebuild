# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

HORDE_APPLICATIONS="dimp imp ingo kronolith mimp mnemo nag turba"

inherit horde-v2

DESCRIPTION="browser based communication suite"
HOMEPAGE="http://www.horde.org/webmail/"

HORDE_PATCHSET_REV=1

SRC_URI="
	${SRC_URI}
	kolab? ( http://files.pardus.de/horde-webmail-patches-1.2-r${HORDE_PATCHSET_REV}.tar.bz2 )
"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE="crypt kolab ldap mysql oracle postgres"

DEPEND=""
RDEPEND="
	!www-apps/horde
	dev-lang/php[ftp,gd,iconv,imap,nls,session,ssl,xml,crypt?,ldap?,mysql?,oracle?,postgres?]
	dev-php/PEAR-DB
	dev-php/PEAR-Log
	dev-php/PEAR-Mail_Mime
	>=www-apps/horde-pear-1.3
	crypt? ( app-crypt/gnupg )
	kolab? ( dev-lang/php[kolab,sqlite] )
"

#EHORDE_PATCHES="$(use kolab && echo ${WORKDIR}/horde-webmail-kolab.patch)"
#HORDE_RECONFIG="$(use kolab && echo ${FILESDIR}/reconfig.kolab)"
#HORDE_POSTINST="$(use kolab && echo ${FILESDIR}/postinstall-en.txt.kolab)"
