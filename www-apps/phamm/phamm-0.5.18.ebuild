# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

if [[ ${PV} == *9999* ]]; then
	CVS_ECLASS="cvs "
	ECVS_SERVER="cvs.savannah.nongnu.org:/sources/phamm"
	ECVS_MODULE="phamm05"
	S="${WORKDIR}/phamm05"
	KEYWORDS=""
else
	RELEASE_URI="http://open.rhx.it/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

inherit ${CVS_ECLASS} webapp

DESCRIPTION="PHP LDAP Virtual Hosting Manager"
HOMEPAGE="http://www.phamm.org/"

SRC_URI="
	${RELEASE_URI}
	amavis? ( http://www.ijs.si/software/amavisd/LDAP.schema.txt -> amavisd-new.schema )
	ftp? ( http://open.rhx.it/phamm/schema/pureftpd.schema -> pureftpd-phamm.schema )
	radius? ( http://open.rhx.it/phamm/schema/radius.schema -> radius-phamm.schema )
	samba? ( http://open.rhx.it/phamm/schema/samba.schema -> samba-phamm.schema )
"
LICENSE="
	GPL-2
	amavis? ( FDL-1.2 )
	ftp? ( BSD )
	radius? ( as-is )
	samba? ( GPL-3 )
"

IUSE="amavis ftp radius samba"
DEPEND="dev-lang/php[ldap,xml]"
RDEPEND="${DEPEND}"

pkg_setup() {
	webapp_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		cvs_src_unpack
	else
		default
	fi
}

src_install() {

	# Remove CVS subdirs
	[[ ${PV} == *9999* ]] && ecvs_clean

	# Install docs
	local DOCS="CHANGELOG COPYRIGHT INSTALL LIB_FUNCTIONS
		PHAMM-LOGO-USE.POLICY README README.locales README.PLUGINS THANKS TODO"
	dodoc ${DOCS} || die "Failed to install Documentation files."

	webapp_src_preinst

	# Install base examples, schema and docs files
	insinto "/usr/share/doc/${PF}"
	doins -r "${S}/examples" || die "Failed to install examples."
	doins -r "${S}/schema" || die "Failed to install schemas."
	doins -r "${S}/docs" || die "Failed to install docs."

	# Install extra schema files
	insinto "/usr/share/doc/${PF}/schema"
	if use amavis; then doins "${DISTDIR}/amavisd-new.schema" || die "Failed to install amavisd-new schema." ; fi
	if use ftp; then doins "${DISTDIR}/pureftpd-phamm.schema" || die "Failed to install pureftpd schema." ; fi
	if use radius; then doins "${DISTDIR}/radius-phamm.schema" || die "Failed to install radius schema." ; fi
	if use samba; then doins "${DISTDIR}/samba-phamm.schema" || die "Failed to install samba schema." ; fi

	# Install the package
	insinto "${MY_HTDOCSDIR}"
	doins *.php || die "Failed to copy php files."

	if [[ ${PV} == *9999* ]]; then
		newins config.inc.example.php config.inc.php || die "Failed to copy default config file."
	fi

	doins -r DTD || die "Failed to install the DTD dir."
	doins -r lib || die "Failed to install the lib dir."
	doins -r locales || die "Failed to install the locales dir."
	doins -r plugins || die "Failed to install the plugins dir."
	doins -r po || die "Failed to install the po dir."
	doins -r tools || die "Failed to install the tools dir."
	doins -r www-data || die "Failed to install the www-data dir."

	# Protect config files
	webapp_configfile ${MY_HTDOCSDIR}/config.inc.php
	for file in plugins/*; do
		webapp_configfile ${MY_HTDOCSDIR}/${file}
	done

	webapp_src_install
}
