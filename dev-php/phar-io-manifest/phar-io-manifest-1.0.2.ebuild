# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Reading phar.io manifest information from a PHP Archive (PHAR)"
HOMEPAGE="https://github.com/phar-io/manifest"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="examples"

S="${WORKDIR}/manifest-${PV}"

RDEPEND="
	dev-php/fedora-autoloader
	>=dev-php/phar-io-version-2.0.0
	<dev-php/phar-io-version-3.0
	|| (
		dev-lang/php:7.2[phar]
		dev-lang/php:7.1[phar]
		dev-lang/php:7.0[phar]
	)
"

src_install() {
	insinto /usr/share/php/PharIo/Manifest
	doins -r src/*
	doins "${FILESDIR}/autoload.php"
	dodoc README.md
	use examples && dodoc -r examples
}
