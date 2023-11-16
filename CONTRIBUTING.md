# Contribution Guidelines

This document outlines the guidelines for contributing to the Indexing Your
Heart project and any of its subprojects such as Marteau.

> **Warning**  
> For the most up-to-date information, check the Notion page that contains these
> guidelines.

## Ensure files have the appropriate headers

Indexing Your Heart is non-violent software licensed under the Cooperative
Non-violent Public License; as such, source code files include a license header
that informs the end user of this license and directs them to where they can
read their rights.

All source code files in the project must include the license header at the top
of the file, as written below:

> This file is part of Indexing Your Heart.
> 
> Indexing Your Heart is non-violent software: you can use, redistribute, and/or
> modify it under the terms of the CNPLv7 as found in the LICENSE file in the
> source code root directory or at
> <[https://git.pixie.town/thufie/npl-builder](https://git.pixie.town/thufie/npl-builder)>.
> 
> Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted
> by applicable law. See the CNPL for details.
> 

Ensure that the license header text follows the respective line column limit and
wraps around as necessary, and that the text is clearly visible.

**Any pull requests that contain files without this header in place will&nbsp;**
**be rejected.** Files that do not allow developers to add headers such as
SpriteKit scene files, property list files, and JSON files, are exempt from this
policy.

Some examples of this header can be found below:

```swift
//
//  Example File.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 25/1/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
```

- **🏁 SwiftLint file check**
    
    For Swift files registered in the Xcode project for Indexing Your Heart,
    SwiftLint will automatically check for the license header for you.
    

```python
# .gitignore
# Copyright (C) 2022 Marquis Kurt <software@marquiskurt.net>
# This file is part of Indexing Your Heart.
#
# Indexing Your Heart is non-violent software: you can use, redistribute,
# and/or modify it under the terms of the CNPLv7 as found in the LICENSE file
# in the source code root directory or at
# <https://git.pixie.town/thufie/npl-builder>.
#
# Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted
# by applicable law. See the CNPL for details.
```

## Run SwiftLint and SwiftFormat before committing

Swift files in the Xcode project should be formatted in a way that makes the
code readable and less susceptible to errors and code smells. Be sure to have
all Swift files formatted using the SwiftFormat tool and checked using the
SwiftLint tool.

Note that SwiftLint includes the following custom rules:

- Ensuring file headers include the licensing statement
- Ensuring files do not reference the internal codename of the project
- Suggestions for the `for x in where` syntax, when applicable

SwiftFormat also includes the following settings:

- No binary/decimal/hexadecimal/octal grouping
- Inline-commas
- `#ifdef` statements being outdented
- Inlined let patterns (such as `.case(let success)`) instead of being hoisted
- Refrained semicolons
- Argument/collection/parameter wrapping before first element

## Provide meaningful commit messages

Commit messages on this project follow a type-summary-description based approach
that tries to explains as much as possible while being concise. An example is
provided below:

```
:triangular_flag_on_post: Disable rxn_use_guides

User tests on this feature have concluded that the guide wasn't used at
all. Most users didn't discover the feature until late into the game;
by then, users were already familiar with the mechanics and didn't need
a guide to ensure they draw lines within the puzzle bounds. This flag
will be disabled as a result, and it will be removed from the codebase
in future commits.

^HOH-69 stage Review work Testing 15m
```

- The first component of the message contains an emoji using the
  [Gitmoji](https://gitmoji.dev) standard conventions to capture the type of
  change being made.
- The second component is a summary of the changes being made. Try to be as
  descriptive and concise as possible.
    - If a lot of changes have been made with no clear objective, use "Do stuff"
      as the summary; however, this should be avoided at all costs, as it may
      become unclear over time what changes were made.
- Finally, if you want to provide an addition description, separate it with a
  line as a new paragraph. The description should contain details on the change,
  why it was made, and the impact of it. Optionally, YouTrack commands may be
  applied here as well, below the description.

