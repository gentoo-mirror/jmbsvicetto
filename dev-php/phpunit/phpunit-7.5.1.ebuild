# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A PHP Unit Testing framework"
HOMEPAGE="http://phpunit.de"
SRC_URI="https://github.com/sebastianbergmann/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="
	!dev-php/phpunit-mock-objects
	>=dev-php/doctrine-instantiator-1.1
	<dev-php/doctrine-instantiator-2.0
	dev-php/fedora-autoloader
	>=dev-php/File_Iterator-2.0.1
	<dev-php/File_Iterator-3.0
	>=dev-php/myclabs-deepcopy-1.7
	<dev-php/myclabs-deepcopy-2.0
	>=dev-php/phar-io-manifest-1.0.2
	<dev-php/phar-io-manifest-2.0
	>=dev-php/phar-io-version-2.0
	<dev-php/phar-io-version-3.0
	>=dev-php/PHP_CodeCoverage-6.0.7
	<dev-php/PHP_CodeCoverage-7.0
	>=dev-php/PHP_Timer-2.0
	<dev-php/PHP_Timer-3.0
	>=dev-php/phpspec-prophecy-1.7
	<dev-php/phpspec-prophecy-2.0
	>=dev-php/sebastian-comparator-3.0
	<dev-php/sebastian-comparator-4.0
	>=dev-php/sebastian-diff-3.0
	<dev-php/sebastian-diff-4.0
	>=dev-php/sebastian-environment-4.0
	<dev-php/sebastian-environment-5.0
	>=dev-php/sebastian-exporter-3.1
	<dev-php/sebastian-exporter-4.0
	>=dev-php/sebastian-global-state-2.0
	<dev-php/sebastian-global-state-3.0
	>=dev-php/sebastian-object-enumerator-3.0.3
	<dev-php/sebastian-object-enumerator-4.0
	>=dev-php/sebastian-resource-operations-2.0
	<dev-php/sebastian-resource-operations-3.0
	>=dev-php/sebastian-version-2.0.1
	<dev-php/sebastian-version-3.0
	>=dev-php/Text_Template-1.2.1
	<dev-php/Text_Template-2.0
	|| (
		dev-lang/php:7.2[cli,json,unicode,xml]
		dev-lang/php:7.1[cli,json,unicode,xml]
	)
"

src_install() {
	insinto /usr/share/php/PHPUnit
	doins -r src/*
	insinto /usr/share/php/PHPUnit/vendor
	doins "${FILESDIR}/autoload.php"
	exeinto /usr/share/php/PHPUnit
	doexe phpunit
	dosym ../share/php/PHPUnit/phpunit /usr/bin/phpunit
}

pkg_postinst() {
	elog "${PN} can optionally use json, pdo-sqlite and pdo-mysql features."
	elog "If you want those, emerge dev-lang/php with USE=\"json pdo sqlite mysql\"."
}
