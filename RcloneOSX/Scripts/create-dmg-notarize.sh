#!/bin/bash
set -euo pipefail

if [ "${CONFIGURATION}" != "Release" ]; then
	echo "[SKIP] Not building an Release configuration, skipping DMG creation"
	exit
fi

RCLONEOSX_DMG_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/RcloneOSX/Info.plist")
RCLONEOSX_DMG="${BUILT_PRODUCTS_DIR}/RcloneOSX-${RCLONEOSX_DMG_VERSION}.dmg"
RCLONEOSX_APP="${BUILT_PRODUCTS_DIR}/RcloneOSX.app"
RCLONEOSX_APP_RESOURCES="${RCLONEOSX_APP}/Contents/Resources"

CREATE_DMG="${SOURCE_ROOT}/3thparty/github.com/andreyvit/create-dmg/create-dmg"
STAGING_DIR="${BUILT_PRODUCTS_DIR}/staging/dmg"
STAGING_APP="${STAGING_DIR}/RcloneOSX.app"
DMG_TEMPLATE_DIR="${SOURCE_ROOT}/Scripts/Templates/DMG"
DEFAULT_IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID" | head -1 | cut -f 4 -d " " || true)

if [ -f "${RCLONEOSX_DMG}" ]; then
	echo "-- RcloneOSX dmg already created"
	echo "   > ${RCLONEOSX_DMG}"
else
	echo "-- Creating RcloneOSX dmg"
	echo "   > ${RCLONEOSX_DMG}"
	rm -rf ${STAGING_DIR}
	mkdir -p ${STAGING_DIR}
	cp -a -p ${RCLONEOSX_APP} ${STAGING_DIR}

	${CREATE_DMG} \
		--volname "RcloneOSX" \
		--volicon "${RCLONEOSX_APP_RESOURCES}/AppIcon.icns" \
		--background "${DMG_TEMPLATE_DIR}/background.png" \
		--window-pos -1 -1 \
		--window-size 480 540 \
		--icon "RcloneOSX.app" 240 130 \
		--hide-extension RcloneOSX.app \
		--app-drop-link 240 380 \
		${RCLONEOSX_DMG} \
		${STAGING_DIR}

fi
