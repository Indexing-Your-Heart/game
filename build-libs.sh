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

__target="all"
__preclean=true
__library=""

__fbold=$(tput bold)
__freset=$(tput sgr0)

__swiftbuilddir="../.mbuild"
__swiftcachedir="../.mcache"
__xcodebuilddir="../.mxcbuild"
__xcodecachedir="../.mxcache"

# Prints the help message.
help() {
	echo "Builds the corresponding dependency libraries."
	echo
	echo "Syntax: build-libs [-f|h|l <libname>|t <ios|mac|all>] [LIBRARY]"
	echo "options:"
	echo "h     Print this Help."
	echo "t     Builds libraries for the specified target."
	echo "l     The output library name."
	echo "f     Skips deleting existing dependency files before building."
	echo
}

# Builds the libraries for iOS (framework).
build_ios_lib() {
	echo "${__fbold}Building library [$1] for iOS.${__freset}"
    if [ ! command -v xcbeautify &> /dev/null ]; then
    	xcodebuild -scheme "$1" -destination 'generic/platform=iOS' \
            -derivedDataPath $__xcodebuilddir -skipPackagePluginValidation \
            -clonedSourcePackagesDirPath $__xcodecachedir \
            -configuration Release >> ../$1_build.log
	elif [ ! -z "$NOVA_TASK_NAME" ]; then
		xcodebuild -scheme "$1" -destination 'generic/platform=iOS' \
		-derivedDataPath $__xcodebuilddir -skipPackagePluginValidation \
		-clonedSourcePackagesDirPath $__xcodecachedir \
		-configuration Release
    else
        xcodebuild -scheme "$1" -destination 'generic/platform=iOS' \
            -derivedDataPath $__xcodebuilddir -skipPackagePluginValidation \
            -clonedSourcePackagesDirPath $__xcodecachedir \
            -configuration Release | xcbeautify
    fi
	echo "Copying [$1] library binaries to Shounin/bin."
	buildpath="$__xcodebuilddir/Build/Products/Release-iphoneos/PackageFrameworks"
	cp -af "$buildpath/$1.framework" "../Shounin/bin/ios/$1.framework"
	if ! [ -e "Shounin/bin/ios/SwiftGodotCore.framework" ]; then
		cp -af "$buildpath/SwiftGodotCore.framework" "../Shounin/bin/ios/SwiftGodotCore.framework"
	fi
	echo "Library built [$1] for iOS."
}

# Builds the libraries for macOS (dylib) x86_64 and arm64 into a single library.
build_mac_lib() {
	echo "${__fbold}Building library [$1] for macOS.${__freset}"
    if [ ! command -v xcbeautify &> /dev/null ]; then
        swift build --configuration release --triple arm64-apple-macosx \
            --scratch-path $__swiftbuilddir --cache-path $__swiftcachedir >> ../$1_build.log
	elif [ ! -z "$NOVA_TASK_NAME" ]; then
		swift build --configuration release --triple arm64-apple-macosx \
		--scratch-path $__swiftbuilddir --cache-path $__swiftcachedir
    else
        swift build --configuration release --triple arm64-apple-macosx \
            --scratch-path $__swiftbuilddir --cache-path $__swiftcachedir | xcbeautify
    fi
	echo "Copying [$1] library binaries to Shounin/bin."
	buildpath="$__swiftbuilddir/arm64-apple-macosx/release"
	cp "$buildpath/lib$1.dylib" ../Shounin/bin/mac
	if ! [ -e "Shounin/bin/mac/SwiftGodotCore.framework" ]; then
		cp -af "$buildpath/SwiftGodotCore.framework" "../Shounin/bin/mac/"
	fi
	echo "Library built [$1] for macOS."
}

# Logs when the build began.
log_start() {
	if [[ -z $__library ]]; then
		echo "Build Log for $1" >> $1_build.log
		echo "Start: $(date)" >> $1_build.log
	
	else
		echo "Build Log for $__library (Host: $1)" >> "${__library}_build.log"
		echo "Start: $(date)" >> "${__library}_build.log"
	fi
}

# Logs when the build ended.
log_end() {
	if [[ -z $__library ]]; then
		echo "Build finished" >> $1_build.log
		echo "End: $(date)" >> $1_build.log
	
	else
		echo "Build finished" >> "${__library}_build.log"
		echo "End: $(date)" >> "${__library}_build.log"
	fi
}

# Builds the Swift package dynamic libraries and copies the files into Shounin.
build_lib() {
	echo "Building for target: $__target."
	if ! { [ -z "$NOVA_TASK_NAME" ] && [ command -v xcbeautify &> /dev/null ]; }; then
		log_start
	fi

	cd "$1"
	if [[ "$__target" = "all" || "$__target" = "mac" ]]; then
		if [[ -z $__library ]]; then
			build_mac_lib "$1"
		else
			build_mac_lib "$__library"
		fi
	fi
	if [[ "$__target" = "all" || "$__target" = "ios" ]]; then
		if [[ -z $__library ]]; then
			build_ios_lib "$1"
		else
			build_ios_lib "$__library"
		fi
	fi
	cd ..
	if ! { [ -z "$NOVA_TASK_NAME" ] && [ command -v xcbeautify &> /dev/null ]; }; then
		log_end
	fi
}

# Parses options before reading list of files.
while getopts ":fhl:t:" option; do
	case $option in
		h)
	   		help
			exit;;
		i)
			__maconly=false
			__iosonly=true;;
		f)
			__preclean=false;;
		l)
			__library="$OPTARG";;
		t)
			__target="$OPTARG";;
		\?)
			echo "Err: invalid options"
			exit 1;;
	esac
done

shift "$((OPTIND-1))"

if [[ -e "Shounin/bin/mac/SwiftGodotCore.framework" && $__preclean = true ]]; then
	echo "Removing old Swift Godot framework. This will be rebuilt."
	rm -rf Shounin/bin/mac/SwiftGodotCore.framework
fi

if [[ -e "Shounin/bin/ios/SwiftGodotCore.framework" && $__preclean = true ]]; then
	echo "Removing old Swift Godot framework. This will be rebuilt."
	rm -rf Shounin/bin/ios/SwiftGodotCore.framework
fi

build_lib "$1"
