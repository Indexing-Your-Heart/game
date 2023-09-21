# ``AshashatCore``

Write words in the [ʔaʃaʃat] conlang fluidly.

## Overview

[ʔaʃaʃat] is a declarative, polysynthetic conlang designed by software developers for use in video games or applications
where having a conlang may benefit the quality of the product. It includes its own unique writing system and offers
extensibility that feels natural to developers that have experience in writing user interfaces declaratively, such as in
React.js, SwiftUI, and Jetpack Compose.

**AshashatCore** is the primary package that provides the tooling for creating words, phrases, and sentences.

> Important: Because [ʔaʃaʃat] has a unique writing system that is not easily romanized, words and morphemes written for
> [ʔaʃaʃat] will be written using the International Phonetic Alphabet (IPA), which provides a one-to-one mapping for
> sounds to written symbols.

### Featured Articles

@Links(visualStyle: detailedGrid) {
    - <doc:What-is-Ashashat>
    - <doc:Morphology>
}

## Topics

### [ʔaʃaʃat] Basics

- <doc:What-is-Ashashat>

### Morphology

The following types are the building blocks that provide the APIs for building [ʔaʃaʃat] words and phrases.

- <doc:Morphology>
- <doc:Modifiers>
- ``AshashatWord``
- ``AshashatRepairStrategy``

### Primitive Types

The following types represent the small list of primitives that [ʔaʃaʃat] supports as free morphemes.

- ``AshashatPrimitive``
- ``AshashatShape``

### Linguistic Backing

The following types are the foundational blocks that build up the [ʔaʃaʃat] word builder. They offer ai means to create
linguistic morphemes in a polysynthetic manner.

- ``LinguisticRepresentable``
- ``PhonotacticRepairStrategy``
- ``DefaultRepairStrategy``
- ``Syllable``
