# Indexing Your Heart (Codename "Head Over Heels")

**Indexing Your Heart** is an upcoming A Witness-like puzzle game from _Created by
Marquis Kurt_ about a transfemme pansexual anthropomorphic coyote falling in love
with a highly-skilled artificial intelligence and machine learning engineer in New
Rollinsport. Explore Chelsea Roslyn’s inner world with puzzles that present many
ideas about her own thoughts and feelings, while following the story of her finding
the love of her life, Sam.

> :warning: This project is still in its infancy, so some details and mechanics may
> not work as intended. If you'd like to support the project,
> [consider supporting the developers on Ko-fi][kofi].

[kofi]: https://ko-fi.com/marquiskurt
[gh-badge]: https://github.com/Indexing-Your-Heart/head-over-heels/actions/workflows/tests.yml/badge.svg

## Getting started: Build from source

**Required Tools**

- Xcode 14 or later
- macOS 13 (Ventura) or later
- Just (`brew install just`)
- Godot 4.0.x

**Optional Tools**

- Salmon 9 font family
- SwiftLint and SwiftFormat (used internally for code formatting)
- Xcode Command Line Tools

Start by cloning the repository using `gh repo clone` or `git clone --recursive`.
Then, run `just build-all-deps` to build the required dependencies for the internal
extensions that the main game uses.

From here, you can open the Shounin project in Godot or run `just edit-game` to open
Godot automatically.

> **Note**  
> Using `just edit-game` assumes that you have the Godot binary in your PATH.

### Editing Dependencies

If you need to edit any of the dependent libraries, you can run `just edit-deps` or
open the Indexing Your Heart.xcworkspace file. This will open Xcode with all the
Swift packages used to build the libraries that the Godot project utilizes.

### Exporting Requirements

Generally, you can export the Godot project like any other typical Godot project,
with the following caveats/requirements:

- **The dependent libraries currently only build for macOS and iOS.** They do not
  build for any other platform.
- **The JSON files in the data folder must be included.** Add `data/*.json` to the
  required paths to export in the Resources tab of each target you'd like to build
  for.

### Using Salmon 9 Fonts

> **Warning**
> This documentation is not updated to reflect the new code structure. This will
> change over time.

By default, this project does _not_ include the Salmon 9 font family per its license
agreement. Instead, great open-source equivalents are provided so that the project
builds and renders correctly.

If you have purchased the Salmon 9 font family and want to use those fonts in the
game, replace the following files with the corresponding family variants:

- **Monospace** (`Assets/Fonts/Salmon Mono 9 Regular.ttf`): Salmon Mono 9
  Regular
- **Monospace (Bold)** (`Assets/Fonts/Salmon Mono 9 Bold.ttf`): Salmon Mono 9
  Bold
- **Sans-serif** (`Assets/Fonts/Salmon Sans 9 Regular.ttf`): Salmon Sans 9
  Regular
- **Sans-serif (Bold)** (`Assets/Fonts/Salmon Sans 9 Bold.ttf`): Salmon Sans 9
  Bold
- **Serif** (`Assets/Fonts/Salmon Serif 9 Regular.ttf`): Salmon Serif 9
  Regular
- **Serif (Bold)** (`Assets/Fonts/Salmon Serif 9 Bold.ttf`): Salmon Serif 9
  Bold

If you have not purchased the font and would like to do so, you can find the font on
Phildjii's page on Itch.io at https://phildjii.itch.io/salmon-family.

### Using the utilities package (Marteau)

The Marteau package (`marteau`) includes utilities for handling helper functions
such as:

- Updating build configurations
- Converting Markdown documents to Jenson timelines

More information on how to install and use Marteau can be found on the source code
repository for Marteau at https://github.com/Indexing-Your-Heart/marteau.

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

Additionally, it contains libraries and projects under ethical-source licenses:

- JensonKit: Cooperative Non-violent Public Licnese (v7+)

Finally, it contains other assets with custom licenses:

- Modern Interiors: LimeZu (see licensed in Assets/Tilesets/README.txt)

You can also view the full list of contributors in the
[CONTRIBUTORS.md](./CONTRIBUTORS.md) file.
