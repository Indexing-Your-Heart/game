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

# The path where the package cache is stored.
dep_cache := "~/Library/Developer/Xcode/DerivedData/itanium"

# The editor when updating packages.
dep_editor := `which xed`

# The date and time the action was performed.
exec_date := `date "+%d-%m-%Y.%H-%M-%S"`

# Build a specified set of dependencies with some flags
build-dep LIB_FLAGS +DEPENDENCIES: (fetch-remote-deps)
	./build-libs.sh {{LIB_FLAGS}} {{DEPENDENCIES}}

# Build all dependencies
build-all-deps:
	just build-dep '-a -l ProtractorGodotInterop' Protractor
	just build-dep '-a -f' Ashashat
	just build-dep '-a -f' AnthroBase
	just build-dep '-a -f' JensonGodotKit

# Builds the SwiftGodot xcframework.
build-swift-godot:
	#!/bin/sh
	cd SwiftGodot-Source
	touch nodeploy
	VERSION="nodeploy" NOTES="./nodeploy" SWIFT_GODOT_NODEPLOY=true make build-release
	rm -r nodeploy
	cd ..
	cp -rf ~/sg-builds/SwiftGodot.xcframework SwiftGodot
	if [ -z "$SKIP_CLEAN" ]; then
		rm -rf ~/sg-builds
		rm SwiftGodot-Source/Package.resolved
	fi

# Cleans alls dependencies, logs, etc.
clean:
	just clean-all-deps
	just clean-logs

# Cleans a specified set of dependencies
clean-dep +DEPENDENCIES:
	#!/bin/sh
	for DEPENDENCY in {{DEPENDENCIES}}; do
		cd $DEPENDENCY && rm -rf .build xcbuild && cd ..
	done

# Cleans all dependencies
clean-all-deps:
	just clean-dep Protractor
	just clean-dep Ashashat
	just clean-dep AnthroBase
	just clean-dep JensonGodotKit
	rm -rf {{dep_cache}}
	rm -f *_build.log

# Cleans all logs built from a Just command.
clean-logs:
	rm -f *_build.log swiftlint_*.log

# Codesigns the dependency dylibs.
codesign-deps IDENTITY:
	codesign -s "{{IDENTITY}}" Shounin/bin/mac/*.dylib

# Opens the dependent package in dep_editor for editing.
edit-dep DEPENDENCY:
	{{dep_editor}} {{DEPENDENCY}}

# Fetches the marteau toolchain
fetch-tools:
	brew tap indexing-your-heart/packages
	brew install marteau

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
	just format-dep Protractor AnthroBase JensonGodotKit

# Test a specified set of dependencies
test-dep +DEPENDENCIES:
	#!/bin/sh
	for DEPENDENCY in {{DEPENDENCIES}}; do
		cd $DEPENDENCY && swift test && rm -rf .build && cd ..
	done

# Test all dependencies
test-all-deps:
	just test-dep Protractor

# Runs the integration tests through Godot.
test-game:
	{{gdengine}} {{godot_args}} -s -d addons/gut/gut_cmdln.gd \
	-gdir=res://tests -gprefix=test_ -gsuffix=.gd -gexit -ginclude_subdirs \
	-gjunit_xml_file=../integration_results_{{exec_date}}.xml -glog=2

# Dry run the game locally
dry-run:
	{{gdengine}} {{godot_args}}

# Edits the script that builds libraries
edit-build-lib:
	{{editor}} ./build-libs.sh

# Edits dependencies in Xcode
edit-deps:
	xed Indexing\ Your\ Heart.xcworkspace

# Open Godot editor
edit-game:
	{{gdengine}} {{godot_args}} -e

# Edits this Justfile
edit-just:
	{{editor}} {{justfile()}}

# Runs SwiftLint on library code
lint:
	swiftlint lint --config .swiftlint.yml --output swiftlint_{{exec_date}}.log

# Unswizzles protected images
unswizzle-assets:
	#!/bin/sh
	for file in Shounin/resources/characters/*.swizzle; do
		marteau unswizzle "$file" "${file%.swizzle}.png"
	done