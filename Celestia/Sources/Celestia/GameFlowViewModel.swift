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

import Combine
import Foundation

public class CelestialFlowViewModel: ObservableObject {
    @Published private var blocks = [CelestialFlowConfiguration]()
    public var currentBlock: CelestialFlowConfiguration? { blocks.first }

    public enum InsertionState {
        case beforeCurrent
        case afterCurrent
        case afterLast
    }

    public convenience init() {
        self.init(with: [])
    }

    public init(with blocks: [CelestialFlowConfiguration]) {
        self.blocks = blocks
    }

    public func insert(blocks: [CelestialFlowConfiguration], at insertionState: InsertionState = .afterLast) {
        switch insertionState {
        case .afterLast:
            self.blocks.append(contentsOf: blocks)
        case .afterCurrent:
            self.blocks.insert(contentsOf: blocks, at: 1)
        case .beforeCurrent:
            self.blocks.insert(contentsOf: blocks, at: 0)
        }
    }

    public func next() {
        blocks.removeFirst()
    }
}
