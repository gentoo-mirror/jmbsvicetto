# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

HORDE_APPLICATIONS="dimp imp ingo kronolith mimp mnemo nag turba"

inherit horde-v2

DESCRIPTION="browser based communication suite"
HOMEPAGE="http://www.horde.org/webmail/"

HORDE_PATCHSET_REV=1

KEYWORDS="~amd64"
IUSE="crypt ldap mysql oracle postgres"

DEPEND=""
RDEPEND="
	!www-apps/horde
	dev-lang/php[ftp,gd,iconv,imap,nls,session,ssl,xml,crypt?,ldap?,mysql?,oracle?,postgres?]
	dev-php/PEAR-DB
	dev-php/PEAR-Log
	dev-php/PEAR-Mail_Mime
	>=www-apps/horde-pear-1.3
	crypt? ( app-crypt/gnupg )
"
