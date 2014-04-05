# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KERNEL_SOURCES="hardened-sources"
KERNEL_NAME="hardened"
KERNEL_PV="3.13.2"
KERNEL_REVISION="r3"
KERNEL_VERSION="${KERNEL_PV}-${KERNEL_REVISION}"
GENKERNEL_URI="genkernel-x86_64-${KERNEL_VERSION}"

KERNEL_DIR="linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}"
KERNEL_PKG="${PN/-source/}-kernel-${PVR}.tbz2"
MODULES_PKG="${PN/-source/}-modules-${PVR}.tbz2"
BUILD_DIR="/home/upload-kernel/"

DESCRIPTION="Package to build kernel + initramfs for Gentoo infra boxes"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Infrastructure"
IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-fs/lvm2
	sys-kernel/genkernel
	=sys-kernel/${KERNEL_SOURCES}-${KERNEL_VERSION}
"

S="${WORKDIR}"

src_unpack() {
	# copy the kernel sources
	mkdir -p usr/src
	cp -a "/usr/src/linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}" usr/src || die
}

src_compile() {

	addpredict "/etc/kernels"
	addpredict "/dev"

	# call genkernel to build the kernel + initramfs
	genkernel --minkernpackage="/${KERNEL_PKG}" --modulespackage="/${MODULES_PKG}" \
		--kernel-config="${FILESDIR}/${KERNEL_SOURCES}-${KERNEL_VERSION}".config \
		--mdadm --mdadm-config="${FILESDIR}/mdadm.conf" \
		--lvm --disklabel --busybox --no-install --no-save-config \
		--logfile=${T}/genkernel.log --cachedir=${T}/cache --tempdir=${T}/tmp \
		--kerneldir="${S}/usr/src/linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}"  \
		--module-prefix=${T} all
}

pkg_preinst() {

	# copy the built kernel + initramfs
	cp "${D}${KERNEL_PKG}" "${BUILD_DIR}"
	cp "${D}${MODULES_PKG}" "${BUILD_DIR}"

	# mirror the packages
	# scp ...
}
