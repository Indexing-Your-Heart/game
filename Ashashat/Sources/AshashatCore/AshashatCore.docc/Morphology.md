# Morphology

Understand the morphological principles [ʔaʃaʃat] employs.

## Overview

[ʔaʃaʃat] uses a variety of prefixes, suffixes, infixes, circumfixes, and partial reduplications to form new words on
top of an existing base root. These affixes and reduplications will be referred to as “modifiers” for convenience and
are discussed in detail in <doc:Modifiers>.

## Creating words with repair strategies

In [ʔaʃaʃat], it is very rare that a word is constructed via repair strategies. This merely stems from the fact that,
by design, [ʔaʃaʃat] allows you to describe any word or concept in question with the right set of modifiers.

However, there are a couple of cases in which using repair strategies becomes necessary. For example, business names
such as Apple Inc. will be created with repair strategies to disambiguate from the apple fruit.  Likewise, eponyms and
coined words are borrowed in using repair strategies.

> Important: Currently, AshashatCore does not support writing these words using repair strategies.

## The Noun

The *noun* is the most common and vital lexical category of the [ʔaʃaʃat] language. It is constructed of a base word
with a series of modifiers that account for qualities such as color, size, number, possession. AshashatCore represents
this as the ``AshashatWord`` type.

### The Primitives

[ʔaʃaʃat] has a small set of free morphemes that act as the primitives of word creation. These primitives are available
in the ``AshashatPrimitive`` type.

| English primitive    | [ʔaʃaʃat]         | Primitive type case          |
|:-------------------- |:----------------- | :--------------------------- |
| Person               | pubaʃ             | ``AshashatPrimitive/person`` |
| Animal               | bupeʃ             | ``AshashatPrimitive/animal`` |
| Idea                 | ʔaʃ               | ``AshashatPrimitive/idea``   |
| Thing or thingy      | ʔaʃaʃat           | ``AshashatPrimitive/thing``  |

> Tip: [ʔaʃaʃat] is used when a noun cannot be described by its physical shape, except when it is an abstract idea.
> Abstract ideas and/or concepts use the primitive [ʔaʃ]. For example, the primitive in “software” is [ʔaʃaʃat],
> whereas the primitive in “love” is [ʔaʃ].

Generally, a word can be described by its shape; shapes are also primitives in this respect. These can be accessed with
the ``AshashatShape`` type.

| English shape | [ʔaʃaʃat] | Shape type case            |
| :------------ | :-------- | :------------------------- |
| ellipse       | puk’      | ``AshashatShape/ellipse``  |
| polygon       | tasubi    | ``AshashatShape/polygon``  |
| cylinder      | kabutui   | ``AshashatShape/cylinder`` |
| slab          | siʃa      | ``AshashatShape/slab``     |
| box           | biba      | ``AshashatShape/box``      |
| pyramid       | ikutet    | ``AshashatShape/pyramid``  |
| cone          | k’i:a     | ``AshashatShape/cone``     |
| sphere        | ʔilin     | ``AshashatShape/sphere``   |


## Further Reading

The following articles provide more context for [ʔaʃaʃat]'s morphology and how to utilize them with AshashatCore.

@Links(visualStyle: list) {
    - <doc:Modifiers>
}
