//
//  main.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 6/9/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftGodot
import SwiftGodotMacros

@PickerNameProvider
enum Fruit: Int {
    case cherry
    case apple
    case banana
}

@NativeHandleDiscarding
class ExampleNode: Node {
    required init() {
        super.init()
    }
}

class MyNode: Node2D {
    @SceneTree(path: "LigmaBalls")
    var ligmaBalls: CharacterBody2D?
}

//class Test {
//    #initSwiftExtension(cdecl: "libanthrobase_entry_point", types: [ExampleNode.self])
//}
