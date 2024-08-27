#
#  Justfile
#  Indexing Your Heart
#
#  Created by Marquis Kurt on 5/21/23.
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
#

# The path to the Godot binary to execute.
gdengine := `which godot`

# The arguments to be passed into Godot, pointing to the game's project files.
godot_args := "--path Shounin"

# The text editor to open when writing files.
editor := 'subl'

# The editor when updating packages.
dep_editor := `which xed`

dep_test_args := "'--parallel --num-workers=1'"

# The date and time the action was performed.
exec_date := `date "+%d-%m-%Y.%H-%M-%S"`

# Codesigns the dependency dylibs.
codesign-extensions IDENTITY:
	codesign -s "{{IDENTITY}}" Shounin/bin/mac/*.dylib

# Creates a distribution package for the Mac App Store or TestFlight.
distribute-mac-app-store PROVISION ENTITLEMENTS:
	scripts/export_mas.sh {{PROVISION}} {{ENTITLEMENTS}}
	open .dist

# Dry run the game locally
dry-run:
	{{gdengine}} {{godot_args}}

# Open Godot editor
edit-game:
	{{gdengine}} {{godot_args}} -e

# Edits this Justfile
edit-just:
	{{editor}} {{justfile()}}

# Unswizzles protected images
unswizzle-assets:
	#!/bin/sh
	for file in Shounin/resources/characters/*.swizzle; do
		marteau unswizzle "$file" "${file%.swizzle}.png"
	done
