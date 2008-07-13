# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit cmake-utils eutils flag-o-matic

DESCRIPTION="Soprano is a library which provides a nice QT interface to RDF storage solutions."
HOMEPAGE="http://sourceforge.net/projects/soprano"
SRC_URI="mirror://sourceforge/soprano/soprano-${PV/_rc1/}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+clucene debug doc elibc_FreeBSD +redland sesame2"

S="${WORKDIR}/${P/_rc1/}"

COMMON_DEPEND="
	>=media-libs/raptor-1.4.16
	x11-libs/qt-core:4[debug?]
	x11-libs/qt-dbus:4[debug?]
	clucene? ( >=dev-cpp/clucene-0.9.19 )
	redland? ( >=dev-libs/rasqal-0.9.15
		>=dev-libs/redland-1.0.6 )
	sesame2? ( >=virtual/jre-1.6.0 )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if ! use sesame2 && ! use redland; then
		eerror "You need at least one backend."
		eerror "Available backends are: sesame, redland"
		die "No backend activated."
	fi
}

src_compile() {
	# Fix automagic dependencies / linking
	if ! use clucene; then
		sed -e '/find_package(CLucene)/s/^/#DONOTFIND /' \
			-i "${S}/CMakeLists.txt" || die "Sed for CLucene automagic dependency failed."
	fi

	if ! use sesame2; then
		sed -e '/find_package(JNI)/ s:^:#DONOTWANT :' \
			-i "${S}"/CMakeLists.txt || die "Deactivating sesame backend failed."
	fi

	if ! use redland; then
		sed -e '/find_package(Redland)/ s:^:#DONOTWANT :' \
			-i "${S}"/CMakeLists.txt || die "Deactivating redland backend failed."
	fi

	if ! use doc; then
		sed -e '/find_package(Doxygen)/s/^/#DONOTFIND /' \
			-i "${S}/CMakeLists.txt" || die "Sed to disable api-docs failed."
	fi

	sed -e '/add_subdirectory(test)/s/^/#DONOTCOMPILE /' \
		-e '/enable_testing/s/^/#DONOTENABLE /' \
		-i "${S}"/CMakeLists.txt || die "Disabling of ${PN} tests failed."
	einfo "Disabled building of ${PN} tests."

	# Fix for missing pthread.h linking
	# NOTE: temporarely fix until a better cmake files patch will be provided.
	use elibc_FreeBSD && append-ldflags "-lpthread"

	cmake-utils_src_compile
}

src_test() {
	sed -e 's/#NOTESTS//' \
		-i "${S}"/CMakeLists.txt || die "Enabling tests failed."
	cmake-utils_src_compile
	ctest --extra-verbose || die "Tests failed."
}
