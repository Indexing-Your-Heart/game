host := `uname -a`

# Build specified dependency
build-dep DEPENDENCY:
	./build-libs.sh {{DEPENDENCY}}

# Build all dependencies
build-deps:
	./build-libs.sh Protractor

# Edits dependencies in Xcode
edit-deps:
	xed Indexing\ Your\ Heart.xcworkspace

# Open Godot editor
edit-game:
	godot --path Shounin -e