# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit mount-boot

KERNEL_SOURCES="hardened-sources"
KERNEL_VERSION="3.13.2-r3"
GENKERNEL_URI="genkernel-x86_64-${KERNEL_VERSION}"
BUILD_DIR="/home/upload-kernel/"
KERNEL_URI="mirror:://gentoo-infra/kernel-${GENKERNEL_URI}"
INIT_URI="mirror:://gentoo-infra/initramfs-${GENKERNEL_URI}"

SRC_URI="!build? ( ${KERNEL_URI} ${INIT_URI} )"
DESCRIPTION="Package to build and or install kernel + initramfs for Gentoo infra boxes"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Infrastructure"
IUSE="build +install"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="!build? ( install )"

DEPEND="sys-kernel/genkernel"
RDEPEND="sys-boot/grub:2"

S="${WORKDIR}"

src_compile() {

	if use build; then
		# get genkernel to build the kernel + initramfs
		echo "compile for use build"
	fi
}

src_install() {

	if use build && use install; then
		# get genkernel to install the kernel + initramfs to ${D}
		echo "install for use build + install"
	fi
}

pkg_preinst() {

	mount-boot_pkg_preinst

	if !use build && use install; then
		# copy the kernel and initramfs to boot
		echo "preinst for use install and !build"
	fi

	# run grub to update the config file
	grub2-mkconfig -o /boot/grub/grub.cfg

	if use build; then
		# mirror the built kernel + initramfs
		echo "copy the files and get them mirrored"
	fi

}
