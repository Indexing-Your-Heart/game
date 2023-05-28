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

# Build a specified set of dependencies with some flags
build-dep LIB_FLAGS +DEPENDENCIES: (fetch-remote-deps)
	./build-libs.sh {{LIB_FLAGS}} {{DEPENDENCIES}}

# Build all dependencies
build-all-deps:
	just build-dep '-l ProtractorGodotInterop' Protractor
	just build-dep '-f' AnthroBase

# Cleans a specified set of dependencies
clean-dep +DEPENDENCIES:
	#!/bin/sh
	for DEPENDENCY in {{DEPENDENCIES}}; do
		cd $DEPENDENCY && rm -rf .build xcbuild && cd ..
	done

# Cleans all dependencies
clean-all-deps:
	just clean-dep Protractor

# Fetches remote dependencies from Git submodules
fetch-remote-deps:
	git submodule update --init --recursive --remote

# Formats the source files in a specified set of dependencies
format-dep +DEPENDENCIES:
	#!/bin/sh
	for DEPENDENCY in {{DEPENDENCIES}}; do
		swiftformat "$DEPENDENCY/Sources" --swiftversion 5.8
	done

# Formats source files in all dependencies
format-all-deps:
	just format-dep Protractor

# Test a specified set of dependencies
test-dep +DEPENDENCIES:
	#!/bin/sh
	for DEPENDENCY in {{DEPENDENCIES}}; do
		cd $DEPENDENCY && swift test && rm -rf .build && cd ..
	done

# Test all dependencies
test-all-deps:
	just test-dep Protractor

# Dry run the game locally
dry-run:
	godot --path Shounin

# Edits dependencies in Xcode
edit-deps:
	xed Indexing\ Your\ Heart.xcworkspace

# Open Godot editor
edit-game:
	godot --path Shounin -e

# Runs SwiftLint on library code
lint:
	swiftlint lint --config .swiftlint.yml