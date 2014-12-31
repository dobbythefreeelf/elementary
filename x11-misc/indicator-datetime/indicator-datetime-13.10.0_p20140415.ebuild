# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils cmake-utils

DESCRIPTION="The Date and Time Indicator - A very, very simple clock"
HOMEPAGE="https://launchpad.net/indicator-datetime"
SRC_URI="http://launchpad.net/ubuntu/+archive/primary/+files/indicator-datetime_13.10.0%2B14.04.20140415.3.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libdbusmenu-0.5.90:3[gtk]
	dev-libs/libical
	dev-libs/properties-cpp
	>=gnome-extra/evolution-data-server-3.5.3
	media-libs/libcanberra
	>=x11-libs/libnotify-0.7.6"
DEPEND="${RDEPEND}"

S="${WORKDIR}/indicator-datetime-13.10.0+14.04.20140415.3"

src_prepare() {
	epatch "${FILESDIR}/${P}-drop-url-dispatcher.patch"

	use nls || sed -i '/add_subdirectory (po)/d' CMakeLists.txt

	cp ${FILESDIR}/GSettings.cmake cmake/
	sed -i 's/UseGSettings/GSettings/' data/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-Denable_tests=OFF
	)

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}