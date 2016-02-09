# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: horde-v2.eclass
# @MAINTAINER:
# Jorge Manuel B. S. Vicetto <jmbsvicetto@gentoo.org>
# @BLURB: Eclass to install horde project packages
# @DESCRIPTION:
# Help manage the horde project http://www.horde.org/
#
# Based on the horde eclass:
# Author: Mike Frysinger <vapier@gentoo.org>
# CVS additions by Chris Aniszczyk <zx@mea-culpa.net>
# SNAP additions by Jonathan Polansky <jpolansky@lsit.ucsb.edu>
#
# This eclass provides generic functions to make the writing of horde
# ebuilds fairly trivial since there are many horde applications and
# they all share the same basic install process.

# @ECLASS-VARIABLE: EHORDE_SNAP
# @DESCRIPTION:
# Track whether this a snapshot version or not

# @ECLASS-VARIABLE: EHORDE_SNAP_BRANCH
# @DESCRIPTION:
# You set this via the ebuild to whatever branch you wish to grab a
# snapshot of.  Typically this is 'HEAD' or 'RELENG'.

# @ECLASS-VARIABLE: EHORDE_SNAP_PV
# @DESCRIPTION:
# The date of the snapshot to fetch

# @ECLASS-VARIABLE: EHORDE_VCS
# @DESCRIPTION:
# Track whether this is a live version or not

# This eclass requires at least EAPI-3
case ${EAPI:-0} in
	5|4|3) : ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

if [[ ${PV} == *9999 ]]; then
	EHORDE_VCS="git-2"
fi

inherit webapp eutils php-pear-r1 ${EHORDE_VCS}

HOMEPAGE="http://www.horde.org/${HORDE_PN}"
LICENSE="LGPL-2"

[[ -z ${HORDE_PN} ]] && HORDE_PN="${PN/horde-}"
[[ -z ${HORDE_MAJ} ]] && HORDE_MAJ=""
HORDE_P="${HORDE_PN}-${PV}"

S=${WORKDIR}/${HORDE_PN}${HORDE_MAJ}-${PV/_/-}

case ${PV} in
	*9999)
		EGIT_REPO_URI="git://github.com/horde/${HORDE_PN}"
		SRC_URI=""
		RESTRICT="mirror"
		;;
	*9998)
		EHORDE_SNAP="true"
		if [[ -z ${EHORDE_SNAP_PV} ]]; then
			let date=$(date +%s)-24*60*60
			EHORDE_SNAP_PV=$(date -d @${date} +%Y-%m-%d)
		fi

		SRC_URI="http://ftp.horde.org/pub/snaps/${EHORDE_SNAP_PV}/${HORDE_PN}-git.tar.gz"
		S=${WORKDIR}/${HORDE_PN}
		;;
	*)
		SRC_URI="http://pear.horde.org/get/${HORDE_P}.tgz"
		;;
esac

IUSE="vhosts"

EXPORT_FUNCTIONS pkg_setup src_unpack src_install pkg_postinst

# INSTALL_DIR is used by webapp.eclass when USE=-vhosts
INSTALL_DIR="/horde"
[[ ${HORDE_PN} != "horde" && ${HORDE_PN} != "horde-groupware" && ${HORDE_PN} != "horde-webmail" ]] && INSTALL_DIR="${INSTALL_DIR}/${HORDE_PN}"

HORDE_APPLICATIONS="${HORDE_APPLICATIONS} ."

horde-v2_pkg_setup() {
	webapp_pkg_setup
}

horde-v2_src_unpack() {
	if [[ -n ${EHORDE_VCS} ]] ; then
		${EHORDE_VCS}_src_unpack
	else
		unpack ${A}
	fi
	cd "${S}"

	[[ -n ${EHORDE_PATCHES} ]] && epatch ${EHORDE_PATCHES}

	for APP in ${HORDE_APPLICATIONS}
	do
		[[ -f ${APP}/test.php ]] && chmod 000 ${APP}/test.php
	done
}

horde-v2_src_install() {
	webapp_src_preinst

	local destdir=${MY_HTDOCSDIR}

	# Work-around when dealing with live sources
	[[ -n ${EHORDE_VCS} ]] && cd ${HORDE_PN}

	# Install docs and then delete them (except for CREDITS which
	# many horde apps include in their help page #121003)
	dodoc README docs/*
	mv docs/CREDITS "${T}"/
	rm -rf COPYING LICENSE README docs/*
	mv "${T}"/CREDITS docs/

	dodir ${destdir}
	cp -r . "${D}"/${destdir}/ || die "install files"

	for APP in ${HORDE_APPLICATIONS}
	do
		for DISTFILE in ${APP}/config/*.dist
		do
			if [[ -f ${DISTFILE/.dist/} ]] ; then
				webapp_configfile "${MY_HTDOCSDIR}"/${DISTFILE/.dist/}
			fi
		done
		if [[ -f ${APP}/config/conf.php ]] ; then
			webapp_serverowned "${MY_HTDOCSDIR}"/${APP}/config/conf.php
			webapp_configfile "${MY_HTDOCSDIR}"/${APP}/config/conf.php
		fi
	done

	[[ -n ${HORDE_RECONFIG} ]] && webapp_hook_script ${HORDE_RECONFIG}
	[[ -n ${HORDE_POSTINST} ]] && webapp_postinst_txt en ${HORDE_POSTINST}

	webapp_src_install
}

horde-v2_pkg_postinst() {
	if [ -e ${ROOT}/usr/share/doc/${PF}/INSTALL* ] ; then
		elog "Please read the INSTALL file in /usr/share/doc/${PF}."
	fi

	einfo "Before this package will work, you have to setup the configuration files."
	einfo "Please review the config/ subdirectory of ${HORDE_PN} in the webroot."

	if [ -e ${ROOT}/usr/share/doc/${PF}/SECURITY* ] ; then
		ewarn
		ewarn "Users are HIGHLY recommended to consult the SECURITY guide in"
		ewarn "/usr/share/doc/${PF} before going into production with Horde."
	fi

	if [[ ${HORDE_PN} != "horde" && ${HORDE_PN} != "horde-groupware" && ${HORDE_PN} != "horde-webmail" ]] ; then
		ewarn
		ewarn "Make sure ${HORDE_PN} is accounted for in Horde\'s root"
		ewarn "    config/registry.php"
	fi

	if [[ -n ${EHORDE_VCS} ]] ; then
		ewarn
		ewarn "Use these live versions at your own risk."
		ewarn "They tend to break things when working with the non live versions of horde."
	fi

	if use vhosts ; then
		ewarn
		ewarn "When installing Horde into a vhost dir, you will need to use the"
		ewarn "-d option so that it is installed into the proper location."
	fi

	webapp_pkg_postinst
}
