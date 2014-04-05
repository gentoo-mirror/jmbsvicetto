# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mount-boot multilib

KERNEL_SOURCES="hardened-sources"
KERNEL_PV="3.13.2"
KERNEL_REVISION="r3"
KERNEL_VERSION="${KERNEL_PV}-${KERNEL_REVISION}"
GENKERNEL_NAME="genkernel-x86_64-${KERNEL_PV}-hardened-${KERNEL_REVISION}"
KERNEL_URI="mirror:://gentoo-infra/${PN}-kernel-${PVR}.tbz2"
MODULES_URI="mirror:://gentoo-infra/${PN}-modules-${PVR}.tbz2"

SRC_URI="${KERNEL_URI} ${INIT_URI}"
DESCRIPTION="Package to install kernel + initramfs for Gentoo infra boxes"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Infrastructure"
IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-boot/grub:2"

S="${WORKDIR}"

src_install() {

	# copy the kernel and initramfs
	insinto /boot
	doins "kernel-${GENKERNEL_NAME}"
	doins "initramfs-${GENKERNEL_NAME}"

	# copy the modules dir
	insinto /$(get_libdir)/modules
	doins -r "${KERNEL_PV}-hardened-${KERNEL_REVISION}"
}

pkg_preinst() {

	mount-boot_pkg_preinst

	# run grub to update the config file
	grub2-mkconfig -o /boot/grub/grub.cfg
}
