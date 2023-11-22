#!/bin/sh
#
#  export_mas.sh
#  Indexing Your Heart
#
#  Created by Marquis Kurt on 23/10/23.
#
#  This file is part of Indexing Your Heart.
#
#  Indexing Your Heart is non-violent software: you can use, redistribute,
#  and/or modify it under the terms of the CNPLv7+ as found in the LICENSE file
#  in the source code root directory or at
#  <https://git.pixie.town/thufie/npl-builder>.
#
#  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent
#  permitted by applicable law. See the CNPL for details.

if test x$2 = x; then
   echo "Usage: export_mas.sh <provisionprofile> <entitlements>"
   exit 1
fi

rm -rf .dist/*.app .dist/*.pkg ||:

if [ ! -f .dist/IndexingYourHeart-MAS.zip ]; then
	echo "Indexing Your Heart Mac App Store product not built. Aborting."
	exit 1
fi

provisionprofile=$1
entitlements=$2

unzip .dist/IndexingYourHeart-MAS.zip -d .dist/
cp provisionprofile ".dist/Indexing Your Heart.app/Contents/embedded.provisionprofile"
codesign -s "Apple Distribution" -f --timestamp \
	".dist/Indexing Your Heart.app/Contents/Frameworks/SwiftGodotCore.framework"
codesign -s "Apple Distribution" -f --timestamp \
	.dist/Indexing\ Your\ Heart.app/Contents/Frameworks/lib*.dylib
codesign -s "Apple Distribution" -f --timestamp -o runtime \
	--entitlements entitlements ".dist/Indexing Your Heart.app"
productbuild --sign "3rd Party Mac Developer Installer" \
	--component ".dist/Indexing Your Heart.app" /Applications .dist/IndexingYourHeart.pkg