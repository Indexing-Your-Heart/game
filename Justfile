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

# Build a specified set of extensions.
build-extension LIB_FLAGS +EXTENSIONS: (fetch-remote-deps)
	./build-libs.sh {{LIB_FLAGS}} {{EXTENSIONS}}

# Builds all the game's extensions for macOS and iOS.
build-extensions:
	# Atoms
	just build-extension '-f' Ashashat
	just build-extension '-f' AnthroBase
	just build-extension '-f' JensonGodotKit

	# Molecules
	just build-extension '-f' Demoscene
	just build-extension '-f' Rollinsport

	# Cleanup
	just copy-extension-dependencies

# Build all extensions for CI
build-extensions-ci:
	# Atoms
	just build-extension '-t mac -f' Ashashat
	just build-extension '-t mac -f' AnthroBase
	just build-extension '-t mac -f' JensonGodotKit

	# Molecules
	just build-extension '-t mac -f' Demoscene
	just build-extension '-t mac -f' Rollinsport

	# Cleanup
	just copy-extension-dependencies

# Cleans alls dependencies, logs, etc.
clean:
	just clean-extensions
	just clean-logs
	just clean-dylibs

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

# Copies the extensions and their dependencies into the iOS folder.
copy-extension-dependencies:
	#!/bin/zsh
	cp .mbuild/release/*.dylib Shounin/bin/mac
	if [ -e ".mxcbuild/Build/Products/Release-iphoneos/PackageFrameworks" ]; then
		rm -rf "Shounin/bin/ios/**"
		for framework in ".mxcbuild/Build/Products/Release-iphoneos/PackageFrameworks/"; do
			cp -af $framework "Shounin/bin/ios/"
		done
	else
		echo "Frameworks are not built, or building failed. Aborting."
	fi

# Creates a distribution package for the Mac App Store or TestFlight.
distribute-mac-app-store PROVISION ENTITLEMENTS:
	./export_mas.sh {{PROVISION}} {{ENTITLEMENTS}}
	open .dist

# Fetches the marteau toolchain
fetch-tools:
	brew tap indexing-your-heart/packages https://gitlab.com/indexing-your-heart/homebrew-packages
	brew install marteau

# Fetches remote dependencies from Git submodules
fetch-remote-deps:
	git submodule update --init --recursive --remote

# Formats the source files in a specified set of extensions
format-extension +EXTENSIONS:
	#!/bin/sh
	for EXTENSION in {{EXTENSIONS}}; do
		swiftformat "$EXTENSION/Sources" --swiftversion 5.9
	done

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
