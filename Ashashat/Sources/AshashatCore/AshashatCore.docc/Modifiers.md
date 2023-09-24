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

### Logical conjunctions

The logical conjunctions are infixes for primitives and/or modifiers that can be used to express negation or
combinational logic, such as “red and blue”. In AshashatCore, this is represented by
``AshashatLogicalConjunctionModifier``.

| English conjunction | [ʔaʃaʃat] | Conjunction modifier case                    |
| :------------------ | :-------- | :------------------------------------------- |
| not                 | sukaʔ     | ``AshashatLogicalConjunctionModifier/not``   |
| never               | sukak’aʔ  | ``AshashatLogicalConjunctionModifier/never`` |
| and                 | suki      | ``AshashatLogicalConjunctionModifier/and``   |
| or                  | suke      | ``AshashatLogicalConjunctionModifier/or``    |
| exclusive or (xor)  | ʃukek’e   | ``AshashatLogicalConjunctionModifier/xor``   |


For example, the modifier [ba | sukaʔa | bin] transliterates to “not markable”. Logical conjunctions can be expressed
using the ``AshashatWord/logicalConjunction(using:)`` modifier:

```swift
let unmarkableIdea: some AshashatWord = {
    AshashatPrimitive.idea
        .action(.markable) { action in
            action.logicalConjunction(using: .not)
        } // produces [ʔaʃabasukaʔabin]
}()
```

> Note: Both [sukak’aʔ] and [ʃukek’e] use intensified duplicants to express the extent of the logic; the last syllable
> is reduplicated and intensified by replacing the [k] consonant with its ejective counterpart, [k’]. This approach to
> these modifiers was taken to reduce the number of combinations needed to express these modifiers.

## Scientific domains

Scientific domain modifiers are circumfixes to primitives and/or modifiers used to denote a scientific quality about an
item.

| Scientific domain | [ʔaʃaʃat] |
| :---------------- | :-------- |
| natural           | isalu     |
| chemical          | ikalu     |
| electrical        | eʃaku     |
| physical          | iʃalu     |


For example, the word [e | siʃa | ʃaku] transliterates to “electrical slab”, which translates to *tablet (like iPad)*.

## Size and scale

Size and scale modifiers are suffixes to primitives and/or modifiers that describe the scale or size of an item.

| Size or scale | [ʔaʃaʃat] |
| :------------ | :-------- |
| small         | ʃa        |
| midsize       | ʃe        |
| big           | ʃi        |
| longwise      | k’aʃa     |
| width wise    | k’iʃi     |


For example, the word [siʃa | ʃa | k’iʃi | suki | ʃi | k’aʃa] transliterates to “slab that is small width wise and big
lengthwise”, which translates to *line*.

## Senses

Sense modifiers are prefixes to primitives and/or modifiers that describe words with respect to the senses.

| Sense        | [ʔaʃaʃat] |
| :----------- | :-------- |
| audio        | aʔa       |
| visual       | iʔi       |
| “sniff able” | eʔe       |
| “taste able” | uʔu       |
| tactile      | ik’i      |


For example, the word [iʔi | ʔaʃ] transliterates to “visual idea”, which translates to *art*.

## Colors

Color modifiers are prefixes to primitives and modifiers that describe the color of an item. They can be combined using
logical intensity operators and are **never** used to describe the race of a person.

| Color  | [ʔaʃaʃat] |
| :----- | :-------- |
| red    | tata      |
| orange | titi      |
| yellow | tutu      |
| green  | nana      |
| blue   | nini      |
| indigo | nene      |
| purple | nunu      |
| black  | ak’a      |
| white  | aʃa       |


For example, the word [titi | uʔu | ʔilin] transliterates to “red tastable/edible sphere”, which translates to *apple*.

> Tip: To disambiguate between the fruit "apple" and the consumer electronics company "Apple, Inc.", “apple” will always
> be written as described above. Apple Inc. is written as a name with repair strategies applied ([e:pulu]).

## Speed

Speed modifiers are prefixes to primitives and modifiers that describe the speed of an action or item in question.

| Speed | [ʔaʃaʃat] |
| :---- | :-------- |
| slow  | ake       |
| fast  | ak'i      |

## Topics

### Plurality and Possession

- ``AshashatWord/pluralized(_:)``
- ``AshashatPluralityModifier``
- ``PluralizedAshashatWord``
- ``AshashatWord/owning()``
- ``PossessedAshashatWord``

### Grammatical Person

- ``AshashatWord/grammaticalPerson(_:)``
- ``AshashatGrammaticalPersonModifier``
- ``GrammaticalPersonAshashatWord``

### Actions

- ``AshashatWord/action(_:)``
- ``AshashatWord/action(_:properties:)``
- ``AshashatActionModifier``
- ``ActionableAshashatWord``

### Logical Conjunctions

- ``AshashatWord/logicalConjunction(using:)``
- ``AshashatLogicalConjunctionModifier``
- ``LogicalAshashatWord``
