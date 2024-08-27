# Indexing Your Heart (Codename "Head Over Heels")

**Indexing Your Heart** is an upcoming hybrid Witness-like puzzle game and
visual novel. Follow Chelsea Roslyn, a lovable anthro-coyote, as she explores the 
mountains towering over New Rollinsport and meets a mysterious obelisk creature
with an existential crisis. Learn the [ʔaʃaʃat] language with cleverly crafted
puzzles and understand the mysteries of the obelisk.

> **Warning**  
> This project is a work in progress. Game mechanics, lore, and other parts of
> the game are still a work in progress and may not be representative of the
> final release. Use at your own risk. If you'd like to support the project,
> [consider supporting the developers on Ko-fi][kofi].

[kofi]: https://ko-fi.com/marquiskurt

## Getting started: Build from source

**Required Tools**

- Godot 4.2.x
- .NET 8 SDK

**Optional Tools**

- Salmon 9 font family

To get started, clone the repository using `gh clone` or `git clone`. From here,
you can either open the Godot project directly via the Shounin directory or use
Visual Studio, Rider, etc. to open the Indexing Your Heart solution and run the
game directly.

> **Important**  
> You may need to unswizzle the assets in the resources directory. Currently,
> this requires the use of the `marteau` tool, which is only officially
> supported on macOS and Linux. For more information, visit the GitLab
> repository at https://gitlab.com/Indexing-Your-Heart/build-tools/marteau.

### Running Test Suite

To run the test suite, you will need to edit the runsettings file included in
this repository to point to your local copy of Godot.

### Exporting Requirements

Generally, you can export the Godot project like any other typical Godot
project, with the following caveats/requirements:

- **The JSON files in the data folder must be included.** Add `data/*.jenson` to
  the required paths to export in the Resources tab of each target you'd like to
  build for.
  
### Using Salmon 9 Fonts

By default, this project does _not_ include the Salmon 9 font family per its
license agreement. Instead, the default system font is loaded
(see Godot's `SystemFont`).

If you have purchased the Salmon 9 font family and want to use those fonts in
the game, replace the following files with the corresponding family variants:

- **Monospace** (`Shounin/resources/gui/salmon/s_mono_regular.ttf`): Salmon Mono
  9 Regular
- **Sans-serif** (`Shounin/resources/gui/salmon/s_sans_regular.ttf`): Salmon Sans
  9 Regular
- **Sans-serif (Bold)** (`Shounin/resources/gui/salmon/s_sans_bold.ttf`): Salmon
  Sans 9 Bold
- **Serif** (`Shounin/resources/gui/salmon/s_serif_regular.ttf`): Salmon Serif 9
  Regular
- **Serif (Bold)** (`Shounin/resources/gui/salmon/s_serif_bold.ttf`): Salmon
  Serif 9 Bold
- **Typewriter** (`Shounin/resources/gui/salmon/s_typewriter_regular.ttf`): Salmon
  Typewriter 9 Regular
- **Typewriter (Bold)** (`Shounin/resources/gui/salmon/s_typewriter_regular.ttf`):
  Salmon Typewriter 9 Bold

If you have not purchased the font and would like to do so, you can find the
font on Phildjii's page on Itch.io at https://phildjii.itch.io/salmon-family.

## Found an issue?

If you've found a bug or want to submit feedback to the project, it is
encouraged that you submit feedback through the project's YouTrack page at
https://youtrack.marquiskurt.net/youtrack/issues/IOH. Additionally, you can
send feedback in our Discord server or by emailing us at
`hello at indexingyourhe.art`.

## Licensing

This project is licensed under the Cooperative Non-Violent Public License, v7 or
later. You can learn more about what your rights are by reading the
[LICENSE.md](./LICENSE.md) file in full.

## Contributions

**Indexing Your Heart (Codename "Head Over Heels")** includes libraries and
projects under open-source licenses:

- Godot: MIT License
- Kadlet: MIT License

Finally, it contains other assets with custom licenses:

- Modern Exteriors: LimeZu (see license in Assets/Tilesets/README.txt)
- Footsteps Pack: ElvGames (see https://elv-games.itch.io/footsteps-sound-fx)

You can also view the full list of contributors in the
[CONTRIBUTORS.md](./CONTRIBUTORS.md) file.
