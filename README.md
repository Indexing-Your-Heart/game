# Indexing Your Heart (Codename "Head Over Heels")

**Indexing Your Heart** is an upcoming hybrid Witness-like puzzle game and visual novel
for iPhone, iPad, and Mac. Follow Chelsea Roslyn, a lovable anthro-coyote, as she explores
the mountains towering over New Rollinsport and meets a mysterious obelisk creature with
an existential crisis. Learn the [ʔaʃaʃat] language with cleverly crafted puzzles and
understand the mysteries of the obelisk.

> **Warning**  
> This project is a work in progress. Game mechanics, lore, and other parts of the game
> are still a work in progress and may not be representative of the final release. Use at
> your own risk. If you'd like to support the project,
> [consider supporting the developers on Ko-fi][kofi].

[kofi]: https://ko-fi.com/marquiskurt

## Getting started: Build from source

**Required Tools**

- Xcode 15 or later
- macOS 14 (Sonoma) or later
- Just (`brew install just`)
- Godot 4.0.x

**Optional Tools**

- Salmon 9 font family
- SwiftLint and SwiftFormat (used internally for code formatting)
- Xcode Command Line Tools

1. Start by cloning the repository using `gh repo clone` or `git clone --recursive`.
2. Next, run `just fetch-tools` to fetch the other tools needed to build the game.
3. Then, run `just build-swift-godot` and `just build-all-deps` to build the required
   dependencies for the internal extensions that the main game uses.
4. Finally, run `just unswizzle-assets` to unswizzle the assets in the game's resources so
   that the game can be built normally.

From here, you can open the Shounin project in Godot through the project manager, or
you can invoke `just edit-game` to open the project directly in the editor.

To run the game as-is, call `just dry-run`. The game will launch as if it were built
and distributed.

> **Note**  
> Using `just edit-game` assumes that the `gdengine` variable in the Justfile is
> pointing to the Godot binary in your `PATH`. Edit this variable to match the path
> of your Godot binary if this doesn't match, or update `PATH` to include the Godot
> binary.

### Editing Dependencies

If you need to edit any of the dependent libraries, you can run `just edit-deps` or
open the Indexing Your Heart.xcworkspace file. This will open Xcode with all the
Swift packages used to build the libraries that the Godot project utilizes.

To rebuild all dependencies after making adjustments, run `just build-all-deps`.
The correct build flags will be applied to ensure binaries for macOS and iOS are
available. Likewise, you can call either `just build-dep` or run `.build-libs.sh` to
build a given dependency.

### Exporting Requirements

Generally, you can export the Godot project like any other typical Godot project,
with the following caveats/requirements:

- **The dependent libraries currently only build for macOS and iOS.** They do not
  build for any other platform.
- **The JSON files in the data folder must be included.** Add `data/*.json` to the
  required paths to export in the Resources tab of each target you'd like to build
  for.

### Using Salmon 9 Fonts

By default, this project does _not_ include the Salmon 9 font family per its license
agreement. Instead, the default system font is loaded (see Godot's `SystemFont`).

If you have purchased the Salmon 9 font family and want to use those fonts in the
game, replace the following files with the corresponding family variants:

- **Monospace** (`Shounin/resources/gui/salmon/s_mono_regular.ttf`): Salmon Mono 9
  Regular
- **Sans-serif** (`Shounin/resources/gui/salmon/s_sans_regular.ttf`): Salmon Sans 9
  Regular
- **Sans-serif (Bold)** (`Shounin/resources/gui/salmon/s_sans_bold.ttf`): Salmon
  Sans 9 Bold
- **Serif** (`Shounin/resources/gui/salmon/s_serif_regular.ttf`): Salmon Serif 9
  Regular
- **Serif (Bold)** (`Shounin/resources/gui/salmon/s_serif_bold.ttf`): Salmon Serif 9
  Bold

If you have not purchased the font and would like to do so, you can find the font on
Phildjii's page on Itch.io at https://phildjii.itch.io/salmon-family.

### Using the utilities package (Marteau)

The Marteau package (`marteau`) includes utilities for handling helper functions
such as:

- Updating build configurations
- Converting Markdown documents to Jenson timelines

### Just Commands

The following is the list of commands available from Just. You can also view this
list by invoking `just -l`.

```
Available recipes:
    build-all-deps           # Build all dependencies
    build-dep LIB_FLAGS +DEPENDENCIES # Build a specified set of dependencies with some flags
    build-swift-godot        # Builds the SwiftGodot xcframework.
    clean                    # Cleans alls dependencies, logs, etc.
    clean-all-deps           # Cleans all dependencies
    clean-dep +DEPENDENCIES  # Cleans a specified set of dependencies
    clean-logs               # Cleans all logs built from a Just command.
    dry-run                  # Dry run the game locally
    edit-build-lib           # Edits the script that builds libraries
    edit-dep DEPENDENCY      # Opens the dependent package in dep_editor for editing.
    edit-deps                # Edits dependencies in Xcode
    edit-game                # Open Godot editor
    edit-just                # Edits this Justfile
    fetch-remote-deps        # Fetches remote dependencies from Git submodules
    fetch-tools              # Fetches the marteau toolchain
    format-all-deps          # Formats source files in all dependencies
    format-dep +DEPENDENCIES # Formats the source files in a specified set of dependencies
    lint                     # Runs SwiftLint on library code
    test-all-deps            # Test all dependencies
    test-dep +DEPENDENCIES   # Test a specified set of dependencies
    test-game                # Runs the integration tests through Godot.
    unswizzle-assets         # Unswizzles protected images
```

> **Note**  
> To install Marteau from Homebrew automatically, run `just fetch-tools`. More information
> use Marteau can be found on the source code repository for Marteau at
> https://github.com/Indexing-Your-Heart/marteau.

## Found an issue?

If you've found a bug or want to submit feedback to the project, it is encouraged
that you submit feedback through the project's Raceway page at
https://feedback.marquiskurt.net/t/indexing-your-heart. Additionally, you can send
feedback in our Discord server or by emailing us at `hello at indexingyourhe.art`.

## Licensing

This project is licensed under the Cooperative Non-Violent Public License, v7 or
later. You can learn more about what your rights are by reading the
[LICENSE.md](./LICENSE.md) file in full.

## Contributions

**Indexing Your Heart (Codename "Head Over Heels")** includes libraries and projects
under open-source licenses:

- SwiftGodot: MIT License
- Godot: MIT License
- Panku Console: MIT License

Additionally, it contains libraries and projects under ethical-source licenses:

- JensonKit: Cooperative Non-violent Public Licnese (v7+)

Finally, it contains other assets with custom licenses:

- Modern Interiors: LimeZu (see licensed in Assets/Tilesets/README.txt)

You can also view the full list of contributors in the
[CONTRIBUTORS.md](./CONTRIBUTORS.md) file.
