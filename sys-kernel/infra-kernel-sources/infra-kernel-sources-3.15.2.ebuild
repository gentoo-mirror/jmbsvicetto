# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit flag-o-matic

KERNEL_SOURCES="hardened-sources"
KERNEL_NAME="hardened"
KERNEL_PV="$PV"
KERNEL_REVISION="$PR"
INFRA_SUFFIX="infra27"

KERNEL_PVR="${KERNEL_PV}-${KERNEL_REVISION}"
KERNEL_PF="${KERNEL_SOURCES}-${KERNEL_PVR}"

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
	>=sys-kernel/genkernel-3.4.49.1
	=sys-kernel/${KERNEL_PF}"
RDEPEND=""

S="${WORKDIR}"

pkg_setup() {
	use amd64 && KARCH="x86_64"
	use x86 && KARCH="x86"

	KERNEL_DIR="linux-${KERNEL_PV}-${KERNEL_NAME}-${KERNEL_REVISION}"
	BINPKG_PVR="${PVR}-${INFRA_SUFFIX}"
	BINPKG_KERNEL="${PN/-sources/}-kernel-${KARCH}-${BINPKG_PVR}.tbz2"
	BINPKG_MODULES="${PN/-sources/}-modules-${KARCH}-${BINPKG_PVR}.tbz2"
	KERNEL_CONFIG="${FILESDIR}"/${KERNEL_PF}-${KARCH}-${INFRA_SUFFIX}.config

	[ -d /usr/src/${KERNEL_DIR} ] || die "kernel dir /usr/src/${KERNEL_DIR} missing"
	[ -f ${KERNEL_CONFIG} ] || die "${KERNEL_CONFIG} missing"
	# we need to be using flags that will result in binaries working on all infra systems
	strip-flags
	filter-flags -march=* -mtune=* -mcpu=* -frecord-gcc-switches
	use amd64 && append-flags -march=x86-64 -mtune=generic
	use x86 && append-flags -march=pentium3 -mtune=generic
}

src_unpack() {
	mkdir -p "${T}"/{cache,tmp,kernel-output}
}

src_prepare() {
	# copy the kernel sources, this is potentially large, but nothing we can do.
	# if it's dirty, the build will fail
	# symlinks do not work either
	mkdir -p "${S}"/usr/src
	cp -a "/usr/src/${KERNEL_DIR}" "${S}"/usr/src || die
	cd "${S}"/usr/src/${KERNEL_DIR}
	_ARCH="$ARCH"
	unset ARCH
	emake mrproper || die "Failed to cleanup"
	export ARCH=$_ARCH
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
	DISTDIR="${ROOT}"//usr/share/genkernel/distfiles \
	CFLAGS="${CFLAGS}" \
	CXXFLAGS="${CXXFLAGS}" \
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
		--no-debug-cleanup \
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
		\
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
