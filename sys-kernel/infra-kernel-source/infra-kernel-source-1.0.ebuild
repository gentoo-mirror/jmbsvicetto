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
	=sys-kernel/genkernel-9999
	=sys-kernel/${KERNEL_SOURCES}-${KERNEL_VERSION}
"

S="${WORKDIR}"

src_unpack() {
	# copy the kernel sources
	#mkdir -p usr/src
	#cp -a "/usr/src/linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}" usr/src || die
	mkdir -p "${T}"/{cache,tmp,kernel-output}
}

# This deliberately runs a very sterile genkernel
# that IGNORES the system /etc/genkernel.conf
# so that we get more reproducable builds
# almost all the options are easy with this except GK_SHARE
genkernel_sterile() {
	_DISTDIR="${DISTDIR}"
	# the parsing of --config seems to be broken in v3.4.44.2
	#--config="${emptyconfig}" \
	emptyconfig="${T}"/empty
	touch "${emptyconfig}"
	CMD_GK_CONFIG="${emptyconfig}" \
	GK_SHARE="${ROOT}"/usr/share/genkernel \
	DISTDIR="${ROOT}"/var/cache/genkernel/src/ \
	genkernel \
		--loglevel=1 \
		--no-menuconfig \
		--no-gconfig \
		--no-xconfig \
		--no-save-config \
		--oldconfig \
		--no-clean \
		--no-mrproper \
		--no-symlink \
		--no-mountboot \
		--no-lvm \
		--no-mdadm \
		--no-dmraid \
		--no-multipath \
		--no-iscsi \
		--no-disklabel \
		--no-luks \
		--no-gpg \
		--no-busybox \
		--no-postclear \
		--no-install \
		--no-zfs \
		--no-keymap \
		--no-e2fsprogs \
		--no-unionfs \
		--no-netboot \
		--compress-initramfs \
		--ramdisk-modules \
		"$@"
}

src_compile() {

	addpredict "/etc/kernels"
	addpredict "/dev"

	# call genkernel to build the kernel + initramfs
	genkernel_sterile \
		--loglevel=5 \
		--makeopts="${MAKEOPTS}" \
		--logfile="${T}"/genkernel.log --cachedir="${T}"/cache --tempdir="${T}"/tmp \
		--minkernpackage="${T}"/${KERNEL_PKG} --modulespackage="${T}"/${MODULES_PKG} \
		--kernel-config="${FILESDIR}/${KERNEL_SOURCES}-${KERNEL_VERSION}".config \
		--kerneldir="/usr/src/linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}"  \
		--kernel-outputdir="${T}/kernel-output" \
		--module-prefix="${T}" \
		--lvm --disklabel --busybox \
		--mdadm --mdadm-config="${FILESDIR}/mdadm.conf" \
		all
}

pkg_preinst() {

	# copy the built kernel + initramfs
	cp "${D}${KERNEL_PKG}" "${BUILD_DIR}"
	cp "${D}${MODULES_PKG}" "${BUILD_DIR}"

	# mirror the packages
	# scp ...
}
