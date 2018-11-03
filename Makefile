all: release
debug:
	xcodebuild -derivedDataPath $(PWD) -configuration Debug -scheme rcloneosx
release:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme rcloneosx
dmg:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme rcloneosx-dmg
dmg-release:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme rcloneosx-dmg-notarize
clean:
	rm -Rf Build
	rm -Rf ModuleCache.noindex
	rm -Rf info.plist
	rm -Rf Logs
