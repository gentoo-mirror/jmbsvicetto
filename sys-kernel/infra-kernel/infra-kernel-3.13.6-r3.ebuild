# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mount-boot multilib

KERNEL_NAME="hardened"
KERNEL_PV="$PV"
KERNEL_REVISION="$PR"
INFRA_SUFFIX="infra27"
KARCH="x86_64"

KERNEL_PVR="${KERNEL_PV}-${KERNEL_REVISION}"
KERNEL_PF="${KERNEL_SOURCES}-${KERNEL_PVR}"

BINPKG_PVR="${PVR}-${INFRA_SUFFIX}"
BINPKG_KERNEL="${PN/-sources/}-kernel-${KARCH}-${BINPKG_PVR}"
BINPKG_MODULES="${PN/-sources/}-modules-${KARCH}-${BINPKG_PVR}"

KERNEL_URI="${BINPKG_KERNEL}.tbz2"
MODULES_URI="${BINPKG_MODULES}.tbz2"

CUSTOM_VERSION="${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}-${INFRA_SUFFIX}"
KERNEL_BIN="kernel-${KARCH}-${CUSTOM_VERSION}"
INITRAMFS_BIN="initramfs-${KARCH}-${CUSTOM_VERSION}"
SYSTEMMAP_BIN="System.map-${KARCH}-${CUSTOM_VERSION}"

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
