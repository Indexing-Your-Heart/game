//
//  GameFlowViewModel.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/1/22.
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
import Combine

class GameFlowViewModel: ObservableObject {
    @Published private var blocks = [FlowConfiguration]()
    var currentBlock: FlowConfiguration? { blocks.first }

    enum InsertionState {
        case beforeCurrent
        case afterCurrent
        case afterLast
    }

    convenience init() {
        self.init(with: [])
    }

    init(with blocks: [FlowConfiguration]) {
        self.blocks = blocks
    }

    func insert(blocks: [FlowConfiguration], at insertionState: InsertionState = .afterLast) {
        switch insertionState {
        case .afterLast:
            self.blocks.append(contentsOf: blocks)
        case .afterCurrent:
            self.blocks.insert(contentsOf: blocks, at: 1)
        case .beforeCurrent:
            self.blocks.insert(contentsOf: blocks, at: 0)
        }
    }

    func next() {
        self.blocks.removeFirst()
    }
}
