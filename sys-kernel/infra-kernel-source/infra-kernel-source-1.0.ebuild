# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

KERNEL_SOURCES="hardened-sources"
KERNEL_NAME="hardened"
KERNEL_PV="3.13.2"
KERNEL_REVISION="r3"
INFRA_SUFFIX="infra26"

KERNEL_PVR="${KERNEL_PV}-${KERNEL_REVISION}"
KERNEL_PF="${KERNEL_SOURCES}-${KERNEL_PVR}"

KERNEL_DIR="linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}"
BINPKG_PVR="${PVR}-${INFRA_SUFFIX}"
BINPKG_KERNEL="${PN/-source/}-kernel-${BINPKG_PVR}.tbz2"
BINPKG_MODULES="${PN/-source/}-modules-${BINPKG_PVR}.tbz2"
KERNEL_CONFIG="${FILESDIR}"/${KERNEL_PF}-${INFRA_SUFFIX}.config

BUILD_DIR="/home/upload-kernel/"

DESCRIPTION="Package to build kernel + initramfs for Gentoo infra boxes"
HOMEPAGE="http://wiki.gentoo.org/wiki/Project:Infrastructure"
IUSE=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-apps/fakeroot
	sys-fs/lvm2
	=sys-kernel/genkernel-9999
	=sys-kernel/${KERNEL_PF}"
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	# copy the kernel sources
	#mkdir -p usr/src
	#cp -a "/usr/src/${KERNEL_DIR}" usr/src || die
	mkdir -p "${T}"/{cache,tmp,kernel-output}
}

# This deliberately runs a very sterile genkernel
# that IGNORES the system /etc/genkernel.conf
# so that we get more reproducable builds
# almost all the options are easy with this except GK_SHARE
# fakeroot is here because genkernel uses mknod still
# which fails as non-root
genkernel_sterile() {
	_DISTDIR="${DISTDIR}"
	# the parsing of --config seems to be broken in v3.4.44.2
	#--config="${emptyconfig}" \
	emptyconfig="${T}"/empty
	touch "${emptyconfig}"
	CMD_GK_CONFIG="${emptyconfig}" \
	GK_SHARE="${ROOT}"/usr/share/genkernel \
	DISTDIR="${ROOT}"/var/cache/genkernel/src/ \
	fakeroot genkernel \
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
		--logfile="${T}"/genkernel.log \
		--cachedir="${T}"/cache \
		--tempdir="${T}"/tmp \
		\
		--makeopts="${MAKEOPTS}" \
		--kerneldir="/usr/src/${KERNEL_DIR}"  \
		--kernel-outputdir="${T}/kernel-output" \
		--kernel-config="${KERNEL_CONFIG}" \
		--module-prefix="${T}" \
		\
		--lvm \
		--disklabel \
		--busybox \
		--e2fsprogs \
		--mdadm --mdadm-config="${FILESDIR}/mdadm.conf-1.0" \
		\
		--minkernpackage="${T}"/${BINPKG_KERNEL} \
		--modulespackage="${T}"/${BINPKG_MODULES} \
		all \
	|| die "genkernel failed"
}

src_install() {
	return 0
}

pkg_preinst() {
	# copy the built kernel + initramfs
	mkdir -p "${BUILD_DIR}"
	cp -f "${T}"/${BINPKG_KERNEL} "${BUILD_DIR}" || die "Failed to copy kernel package"
	cp -f "${T}"/${BINPKG_MODULES} "${BUILD_DIR}" || die "Failed to copy module package"
	einfo "${BINPKG_KERNEL} and ${BINPKG_MODULES} are in ${BUILD_DIR}"
	# mirror the packages
	# scp ...
}
