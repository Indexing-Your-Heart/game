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

# Build a specified set of dependencies with some flags
build-dep LIB_FLAGS +DEPENDENCIES: (fetch-remote-deps)
	./build-libs.sh {{LIB_FLAGS}} {{DEPENDENCIES}}

# Build all dependencies
build-all-deps:
	just build-dep '-f' Demoscene
	just build-dep '-f' Ashashat
	just build-dep '-f' AnthroBase
	just build-dep '-f' JensonGodotKit

# Build all dependencies for CI
build-all-deps-ci:
	just build-dep '-t mac -f' Demoscene
	just build-dep '-t mac -f' Ashashat
	just build-dep '-t mac -f' AnthroBase
	just build-dep '-t mac -f' JensonGodotKit

# Cleans alls dependencies, logs, etc.
clean:
	just clean-all-deps
	just clean-logs

# Cleans all dependencies
clean-all-deps:
	rm -rf .mbuild .mxbuild .mcache .mxcache *_build.log

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
	brew tap indexing-your-heart/packages https://gitlab.com/indexing-your-heart/homebrew-packages
	brew install marteau

# Fetches remote dependencies from Git submodules
fetch-remote-deps:
	git submodule update --init --recursive --remote

# Formats the source files in a specified set of dependencies
format-dep +DEPENDENCIES:
	#!/bin/sh
	for DEPENDENCY in {{DEPENDENCIES}}; do
		swiftformat "$DEPENDENCY/Sources" --swiftversion 5.9
	done

# Formats source files in all dependencies
format-all-deps:
	just format-dep Ashashat AnthroBase Demoscene JensonGodotKit

# Test a specified dependency
test-dep DEPENDENCY SWIFT_ARGS=dep_test_args:
	#!/bin/sh
	cd {{DEPENDENCY}} && swift test {{SWIFT_ARGS}} && rm -rf .build && cd ..

# Test all dependencies
test-all-deps:
	just test-dep Ashashat

# Test all dependencies and store their results for CI.
test-all-deps-ci:
	mkdir -p /tmp/testresults
	just test-dep Ashashat '--parallel --num-workers=1 --xunit-output /tmp/testresults/Ashashat.xml'

# Runs the integration tests through Godot.
test-game:
	{{gdengine}} {{godot_args}} --headless \
	-s -d addons/gut/gut_cmdln.gd \
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
	swiftlint lint --output swiftlint_{{exec_date}}.log

# Unswizzles protected images
unswizzle-assets:
	#!/bin/sh
	for file in Shounin/resources/characters/*.swizzle; do
		marteau unswizzle "$file" "${file%.swizzle}.png"
	done
