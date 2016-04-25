# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit mount-boot multilib

KERNEL_NAME="hardened"
KERNEL_PV="$PV"
KERNEL_REVISION="$PR"
INFRA_SUFFIX="infra27"

KERNEL_PVR="${KERNEL_PV}-${KERNEL_REVISION}"

KARCH_amd64="x86_64"
KARCH_x86="x86"
BINPKG_PVR="${PVR}-${INFRA_SUFFIX}"
BINPKG_KERNEL="${PN/-sources/}-kernel-KARCH-${BINPKG_PVR}"
BINPKG_MODULES="${PN/-sources/}-modules-KARCH-${BINPKG_PVR}"

KERNEL_URI_amd64="amd64? ( ${BINPKG_KERNEL/KARCH/${KARCH_amd64}}.tbz2 )"
KERNEL_URI_x86="x86? ( ${BINPKG_KERNEL/KARCH/${KARCH_x86}}.tbz2 )"
KERNEL_URI="$KERNEL_URI ${KERNEL_URI_amd64}"
#KERNEL_URI="$KERNEL_URI ${KERNEL_URI_x86}"

MODULES_URI_amd64="amd64? ( ${BINPKG_MODULES/KARCH/${KARCH_amd64}}.tbz2 )"
MODULES_URI_x86="x86? ( ${BINPKG_MODULES/KARCH/${KARCH_x86}}.tbz2 )"
MODULES_URI="$MODULES_URI ${MODULES_URI_amd64}"
#MODULES_URI="$MODULES_URI ${MODULES_URI_x86}"

SRC_URI="${KERNEL_URI} ${MODULES_URI}"
DESCRIPTION="Package to install kernel + initramfs for Gentoo infra boxes"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Infrastructure"
IUSE=""
RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-boot/grub:2"

S="${WORKDIR}"

src_install() {

	# Use is not valid in global scope
	use amd64 && KARCH="${KARCH_amd64}"
	use x86 && KARCH="${KARCH_x86}"
	[ -z "$KARCH" ] && die "Your arch is not supported by this build"

	[ "${KERNEL_REVISION}" != "r0" ] && KERNEL_REVISION_STRING=-${KERNEL_REVISION}
	CUSTOM_VERSION="${KERNEL_PV}-${KERNEL_NAME}${KERNEL_REVISION_STRING}-${INFRA_SUFFIX}"
	KNAME="genkernel"
	KERNEL_BIN="kernel-${KNAME}-${KARCH}-${CUSTOM_VERSION}"
	INITRAMFS_BIN="initramfs-${KNAME}-${KARCH}-${CUSTOM_VERSION}"
	SYSTEMMAP_BIN="System.map-${KNAME}-${KARCH}-${CUSTOM_VERSION}"

	# copy the kernel and initramfs
	insinto /boot
	doins "${KERNEL_BIN}"
	doins "${INITRAMFS_BIN}"
	doins "${SYSTEMMAP_BIN}"

	# copy the modules dir
	insinto /$(get_libdir)/modules
	doins -r "lib/modules/${CUSTOM_VERSION}"
}

pkg_preinst() {

	mount-boot_pkg_preinst

	# run grub to update the config file
	grub2-mkconfig -o /boot/grub/grub.cfg
}
