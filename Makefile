all: release
debug:
	xcodebuild -derivedDataPath $(PWD) -configuration Debug -scheme rcloneosx
release:
	xcodebuild -derivedDataPath $(PWD) -configuration Release -scheme rcloneosx
clean:
	rm -Rf Build
	rm -Rf ModuleCache.noindex
	rm -Rf info.plist
