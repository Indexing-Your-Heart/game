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

# WARN: build-dep has been renamed to build-extension.
build-dep LIB_FLAGS +DEPENDENCIES: (fetch-remote-deps)
	echo "WARN: build-dep has been renamed to build-extension."
	just build-extension {{LIB_FLAGS}} {{DEPENDENCIES}}

# Build a specified set of extensions.
build-extension LIB_FLAGS +EXTENSIONS: (fetch-remote-deps)
	./build-libs.sh {{LIB_FLAGS}} {{EXTENSIONS}}

# WARN: build-all-deps has been renamed to build-extensions.
build-all-deps:
	echo "WARN: build-all-deps has been renamed to build-extensions."
	just build-extensions

# Builds all the game's extensions for macOS and iOS.
build-extensions:
	# Atoms
	just build-dep '-f' Ashashat
	just build-dep '-f' AnthroBase
	just build-dep '-f' JensonGodotKit

	# Molecules
	just build-dep '-f' Demoscene
	just build-dep '-f' Rollinsport

# WARN: build-all-deps-ci has been renamed to build-extensions-ci.
build-all-deps-ci:
	echo "WARN: build-all-deps-ci has been renamed to build-extensions-ci."
	just build-extensions-ci

# Build all extensions for CI
build-extensions-ci:
	# Atoms
	just build-dep '-t mac -f' Ashashat
	just build-dep '-t mac -f' AnthroBase
	just build-dep '-t mac -f' JensonGodotKit

	# Molecules
	just build-dep '-t mac -f' Demoscene
	just build-dep '-t mac -f' Rollinsport

# Cleans alls dependencies, logs, etc.
clean:
	just clean-extensions
	just clean-logs
	just clean-dylibs

# WARN: clean-all-deps has been renamed to clean-extensions.
clean-all-deps:
	echo "WARN: clean-all-deps has been renamed to clean-extensions."
	just clean-extensions

# Cleans all built extensions, build folders, and cache.
clean-extensions:
	rm -rf .mbuild .mxbuild .mcache .mxcache *_build.log

# Removes any built dylib files
clean-dylibs:
	rm -rf Shounin/bin/mac/* Shounin/bin/ios/*

# Cleans all logs built from a Just command.
clean-logs:
	rm -f *_build.log swiftlint_*.log

# Codesigns the dependency dylibs.
codesign-extensions IDENTITY:
	codesign -s "{{IDENTITY}}" Shounin/bin/mac/*.dylib

# WARN: codesign-deps has been renamed to codesign-extensions.
codesign-deps IDENTITY:
	echo "WARN: codesign-deps has been renamed to codesign-extensions."
	codesign -s "{{IDENTITY}}" Shounin/bin/mac/*.dylib

# WARN: edit-dep is deprecated and will be removed
edit-dep DEPENDENCY:
	echo "WARN: edit-dep is deprecated and will be removed."
	{{dep_editor}} {{DEPENDENCY}}

# Fetches the marteau toolchain
fetch-tools:
	brew tap indexing-your-heart/packages https://gitlab.com/indexing-your-heart/homebrew-packages
	brew install marteau

# Fetches remote dependencies from Git submodules
fetch-remote-deps:
	git submodule update --init --recursive --remote

# WARN: format-dep has been renamed to format-extension
format-dep +DEPENDENCIES:
	echo "WARN: format-dep has been renamed to format-extension"

# Formats the source files in a specified set of extensions
format-extension +EXTENSIONS:
	#!/bin/sh
	for EXTENSION in {{EXTENSIONS}}; do
		swiftformat "$EXTENSION/Sources" --swiftversion 5.9
	done

# WARN: format-all-deps has been renamed to format-extensions
format-all-deps:
	echo "WARN: format-all-deps has been renamed to format-extensions"

# Formats source files in all extensions
format-extensions:
	just format-extension Ashashat AnthroBase Demoscene JensonGodotKit Rollinsport

# Test a specified extension
test-extension DEPENDENCY SWIFT_ARGS=dep_test_args:
	#!/bin/sh
	cd {{DEPENDENCY}} && swift test {{SWIFT_ARGS}} && rm -rf .build && cd ..

# Test all extensions
test-extensions:
	just test-dep Ashashat

# WARN: test-dep has been renamed to test-extension
test-dep DEPENDENCY SWIFT_ARGS=dep_test_args:
	echo "WARN: test-dep has been renamed to test-extension"
	test-extension {{DEPENDENCY}} {{SWIFT_ARGS}}

# WARN: test-all-deps has been renamed to test-extensions
test-all-deps:
	echo "WARN: test-all-deps has been renamed to test-extensions"
	just test-extensions

# WARN: test-all-deps-ci has been renamed to test-extensions-ci
test-all-deps-ci:
	echo "WARN: test-all-deps-ci has been renamed to test-extensions-ci"
	just test-extensions-ci

# Test all extensions and store their results for CI.
test-extensions-ci:
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

# WARN: edit-deps is deprecated and will be removed.
edit-deps:
	echo "WARN: edit-deps is deprecated and will be removed."
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
