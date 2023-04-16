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
- macOS 12.4 (Monterey) or later

**Optional Tools**

- Salmon 9 font family
- SwiftLint and SwiftFormat (used internally for code formatting)
- Xcode Command Line Tools
- Fastlane (used internally for assistance in CI deployment)
- Tiled (used to create 2D levels)

Start by cloning the repository using `gh repo clone` or `git clone`, then open the
main project file `Indexing Your Heart.xcworkspace`. Ensure the current scheme is
set to **Indexing Your Heart**, then go to **Product > Run** to build and run the
project on your Mac or an iOS simulator.

### Project Modules

Indexing Your Heart is organized into a set of modules, each containing a system
used for the main game.

- **Shounin** is the game project itself, where all of the modules get imported
  into.
- **Paintbrush** is the module that contains the source code for the Paintbrush
  puzzle system. The implementations for these exist in Shounin.
- **Caslon** is the module containing the source code for the Caslon visual novel
  system created for Jenson files
- **Celestia** is the module containing code for observing states and loading the
  game's configuration files such as the flow of game events. This module may also
  contain the logic for the save and load system.
- **Bedrock** is the module that contains the foundational elements of the game
  environment. Implementations are currently found in Shounin.

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

- CranberrySprite: Mozilla Public License (v2)
- Bunker: Mozilla Public License (v2)
- Swift Algorithms: Apache License (v2)
- SKTiled: MIT License

Additionally, it contains libraries and projects under ethical-source licenses:

- JensonKit: Cooperative Non-violent Public Licnese (v7+)

Finally, it contains other assets with custom licenses:

- Modern Interiors: LimeZu (see licensed in Assets/Tilesets/README.txt)

You can also view the full list of contributors in the
[CONTRIBUTORS.md](./CONTRIBUTORS.md) file.
