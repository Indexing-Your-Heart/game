#!/bin/sh
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

# Builds the Swift package dynamic libraries and copies the files into Shounin.
# TODO: Add support for iOS as well.
function build_lib {
	echo "Building library [$1]."
	cd "$1"
	swift build --configuration release --triple arm64-apple-macosx
	swift build --configuration release --triple x86_64-apple-macosx
	lipo -create -output "../Shounin/bin/lib$1.dylib" \
		".build/arm64-apple-macosx/release/lib$1.dylib" \
		".build/x86_64-apple-macosx/release/lib$1.dylib"
	lipo -create -output ../Shounin/bin/libSwiftGodot.dylib \
		.build/arm64-apple-macosx/release/libSwiftGodot.dylib \
		.build/x86_64-apple-macosx/release/libSwiftGodot.dylib
	echo "Library built [$1]."
	cd ..
}

build_lib "Protractor"
