#!/bin/bash
#
#  build-libs.sh
#  Indexing Your Heart
#
#  Created by Marquis Kurt on 5/21/23.
#
#  This file is part of Indexing Your Heart.
#
#  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
#  CNPLv7+ as found in the LICENSE file in the source code root directory or at
#  <https://git.pixie.town/thufie/npl-builder>.
#
#  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
#  details.

__maconly=false
__autoclean=true

# Prints the help message.
help() {
	echo "Builds the corresponding dependency libraries."
	echo
	echo "Syntax: build-libs [-d|h|m] [LIBRARIES]"
	echo "options:"
	echo "d     Skips running cleanup tasks."
	echo "h     Print this Help."
	echo "m     Builds only the libraries for macOS."
	echo
}

# Builds the libraries for iOS (framework).
build_ios_lib() {
	echo "Building library [$1] for iOS."
	xcodebuild -scheme "$1" -destination 'generic/platform=iOS' \
		-derivedDataPath xcbuild -skipPackagePluginValidation \
		-configuration Release
	cp -rf "xcbuild/Build/Products/Release-iphoneos/PackageFrameworks/$1.framework" \
		"../Shounin/bin/$1.framework"
	if ! [ -e "Shounin/bin/SwiftGodot.framework" ]; then
		cp -rf "xcbuild/Build/Products/Release-iphoneos/PackageFrameworks/SwiftGodot.framework" \
			"../Shounin/bin/SwiftGodot.framework"
	fi
	echo "Library built [$1] for iOS."
	if [ "$__autoclean" = true ]; then
		rm -rf xcbuild
	fi
}

# Builds the libraries for macOS (dylib) x86_64 and arm64 into a single library.
build_mac_lib() {
	echo "Building library [$1] for macOS."
	swift build --configuration release --triple arm64-apple-macosx
	swift build --configuration release --triple x86_64-apple-macosx
	lipo -create -output "../Shounin/bin/lib$1.dylib" \
		".build/arm64-apple-macosx/release/lib$1.dylib" \
		".build/x86_64-apple-macosx/release/lib$1.dylib"
	if ! [ -e "Shounin/bin/libSwiftGodot.dylib" ]; then
		lipo -create -output ../Shounin/bin/libSwiftGodot.dylib \
			.build/arm64-apple-macosx/release/libSwiftGodot.dylib \
			.build/x86_64-apple-macosx/release/libSwiftGodot.dylib
	fi
	echo "Library built [$1] for macOS."
	if [ "$__autoclean" = true ]; then
		rm -rf .build
	fi
}

# Builds the Swift package dynamic libraries and copies the files into Shounin.
build_lib() {
	cd "$1"
	build_mac_lib "$1"
	if [ "$__maconly" = true ]; then
		echo "Skipping iOS build [$1]."
		cd ..
		return
	fi
	build_ios_lib "$1"
	cd ..
}

# Parses options before reading list of files.
while getopts ":dhm" option; do
	case $option in
		h)
	   		help
			exit;;
		d)
			__autoclean=false;;
		m)
			__maconly=true;;
		\?)
			echo "Err: invalid options"
			exit 1;;
	esac
done

shift "$((OPTIND-1))"

if [ -e "Shounin/bin/libSwiftGodot.dylib" ]; then
	echo "Removing old Swift Godot dynamic library. This will be rebuilt."
	rm -f Shounin/bin/libSwiftGodot.dylib
fi

if [[ -e "Shounin/bin/SwiftGodot.framework" && "$__maconly" = false ]]; then
	echo "Removing old Swift Godot framework. This will be rebuilt."
	rm -rf Shounin/bin/SwiftGodot.framework
fi

for library in "$@"; do
	build_lib "$library"
done