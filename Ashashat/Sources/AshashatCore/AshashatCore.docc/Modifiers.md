# Modifiers

@Metadata {
    @PageColor(blue)
}

Learn the various modifiers that build up [ʔaʃaʃat] words.

## Overview

All other morphemes in [ʔaʃaʃat] are bound and extend off the primitive types listed in <doc:Morphology>. The following
article details all the modifiers used in [ʔaʃaʃat].

In AshashatCore, modifiers work similarly to SwiftUI view modifiers, and are invoked off any eligible ``AshashatWord``.

```swift
let yourIdea: some AshashatWord = {
    AshashatPrimitive.idea
        .owning()
        .grammaticalPerson(.second)
}()
```

> Important: In most cases, the order in which modifiers are applied matter in constructing a word. This concept stems
> from the technicalities of rendering user interfaces when applying modifiers to them. When a view is given a list of
> modifiers, it makes a copy of the view with each modifier applied, creating a nested view of modifiers.
>
> ```swift
> import AshashatCore
> 
> var yourWords: AshashatWord {
>   AshashatPrimitive.idea
>       .action(.speakable)
>       .pluralized(.some)
>       .owning()
>       .grammaticalPerson(.second)
> }
> ```

### Phonotactic repairs for modifiers

Some modifiers end in a consonant sound such as [t]. If another syllable follows the modifier, a vowel is added to
prevent double consonant collision; typically, the [a] vowel is used. In AshashatCore, when applying modifiers to
words, the ``AshashatRepairStrategy`` is used, which provides these rules automatically.


## Plurals and possessives

The following modifiers account for possession and plurality. These modifiers are applied as a circumfix to a primitive
or a modifier.

| English word        | [ʔaʃaʃat] |
| :------------------ | :-------- |
| none                | i:        |
| some                | isa       |
| many                | isate     |
| owning (possessive) | k’asu:p   |


For example, [i \| ʔaʃaʃata \| sa] (bars used to distinguish affixing) transliterates to “some things”, which forms the
word *something*. This can also be expressed with a word builder in AshashatCore using the
``AshashatWord/pluralized(_:)`` modifier:

```swift
let someThings: some AshashatWord = {
    AshashatPrimitive.idea
        .pluralized(.some)
}()
```

Expressing possession with the [k’asu:p] modifier in an ``AshashatWord`` can be accomplished with the
``AshashatWord/owning()`` modifier:

```swift
let yourIdea: some AshashatWord = {
    AshashatPrimitive.idea
        .owning()
        .grammaticalPerson(.second)
}()
```

### Some vs. Many

Though [isa] and [isate] express plurality, there are some distinctions to be aware of between these two modifiers.

[isa] (``AshashatPluralityModifier/some``) is commonly used to describe countable or a relatively small amount of an
item. It is also used to describe a noun in *opaque plurality*, indicating that the plurality is unknown or is not
relevant to interpret its meaning.

[isate] (``AshashatPluralityModifier/many``) is used to indicate masses or a relatively big amount of an item.

#### Opaque Plurality

[ʔaʃaʃat] includes a concept for plural nouns called *opaque plurality*. Opaque plurality refers to a type of plural in
which the exact plurality is unknown or is not explicitly relevant to determining a word’s meaning. This concept stems
from opaque types, as seen in SwiftUI.

In English, an example of opaque plurality would be “a pile of gravel”. Since the amount of grains in the gravel is not
relevant to interpret the meaning of “a pile of gravel”, it is disregarded.

> Note: Opaque types also appear when creating words using ``AshashatWord`` because of the underlying technologies that
> determine which morphemes are applies where.
>
> ```swift
> let someWord: some AshashatWord {
>     ...
> }
> ```

## Grammatical person

Grammatical person modifiers, prefixes to primitives and/or modifiers, are used to indicate things such as the speaker
and recipient. They are also also stand-ins for pronouns. In AshashatCore, this is represented with the 
``AshashatGrammaticalPersonModifier`` type.

| English grammatical person | [ʔaʃaʃat] | Grammatical person type case                 |
| :------------------------- | :-------- | :------------------------------------------- |
| first person               | ba        | ``AshashatGrammaticalPersonModifier/first``  |
| second person              | bi        | ``AshashatGrammaticalPersonModifier/second`` |
| third person               | bu        | ``AshashatGrammaticalPersonModifier/third``  |

> Pronouns do not take a gender as the gender is “type erased” away, hereby recognizing everyone as a person.


For example, the word [bi | k’a | ʔaʃa | su: p] transliterates to “second person owning idea”, which translates to *your
idea*. Grammatical person can be expressed using the ``AshashatWord/grammaticalPerson(_:)`` modifier:

```swift
let yourIdea: some AshashatWord = {
    AshashatPrimitive.idea
        .owning()
        .grammaticalPerson(.second)
}()
```

### Actions

Action modifiers describe that a certain action can be done on or with the item in question. They are suffixes to
primitives and/or modifiers. In AshashatCore, this is represented as the ``AshashatActionModifier`` type.

| English action | [ʔaʃaʃat] | Action modifier type case              |
| :------------- | :-------- | :------------------------------------- |
| speakable      | kasu      | ``AshashatActionModifier/speakable``   |
| markable       | babin     | ``AshashatActionModifier/markable``    |
| writable       | bapen     | ``AshashatActionModifier/writeable``   |
| destroyable    | k’abi:    | ``AshashatActionModifier/destroyable`` |
| craftable      | pabil     | ``AshashatActionModifier/craftable``   |
| performable    | ʃasu      | ``AshashatActionModifier/performable`` |
| movable        | ʃaku      | ``AshashatActionModifier/movable``     |
| doable         | nalu      | ``AshashatActionModifier/doable``      |
| able to exist  | nalu:     | ``AshashatActionModifier/existing``    |


For example, the word [ʔaʃa | kasu] transliterates to “speakable idea”, which translates to *word*. Action modifiers can
be expressed using the ``AshashatWord/action(_:)`` modifier:

```swift
let word: some AshashatWord = {
    AshashatPrimitive.idea
        .action(.speakable)
}()
```

#### Generic Doable

The modifier [nalu] (``AshashatActionModifier/doable``) is called a *generic doable*, which is an “elsewhere” action
when no other action modifiers can accurately describe or categorize the primitive.

For instance, the word [ʔaʃa | nalu] transliterates to “doable idea”, which indicates that something can be done with
the idea, but the action itself is unclear.


## Topics

### Plurality and Possession

- ``AshashatWord/pluralized(_:)``
- ``AshashatPluralityModifier``
- ``AshashatWord/owning()``

### Grammatical Person

- ``AshashatWord/grammaticalPerson(_:)``
- ``AshashatGrammaticalPersonModifier``

### Actions

- ``AshashatWord/action(_:)``
- ``AshashatActionModifier``
