//
//  SKCarrierNode.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/15/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
//

import SpriteKit

/// A node that puts its children in a stack.
class SKCarrierNode: SKNode {
    /// An enumeration representing the various alignmenx axes a carrier node can use.
    enum AlignmentAxis {
        /// The vertical axis.
        case vertical

        /// The horizontal axis.
        case horizontal
    }

    /// The arranged children in this node.
    var arrangedChildren: [SKNode] { _arrangedChildren }

    /// The spacing between children. Defaults to 0 (no spacing).
    var spacing: CGFloat = 0

    /// The axis where the items will be aligned. Defaults to vertical.
    var alignmentAxis: AlignmentAxis = .vertical

    private var _arrangedChildren: [SKNode]

    override init() {
        _arrangedChildren = []
        super.init()
    }

    init(arrangedChildren: [SKNode]) {
        _arrangedChildren = arrangedChildren
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Adds a child to the carrier and arranges it in view.
    /// - Parameter childNode: The node to add to the carrier.
    func addArrangedChild(_ childNode: SKNode) {
        let offset = alignmentAxis == .vertical ? getVerticalOffset(of: childNode) : getHorizontalOffset(of: childNode)
        childNode.position = childNode.position.translated(by: offset)
        addChild(childNode)
        _arrangedChildren.append(childNode)
    }

    /// Adds an array of children to the carrier and arranges them in view.
    /// - Parameter children: The nodes to add to the carrier.
    func addArrangedChildren(_ children: [SKNode]) {
        children.forEach { self.addArrangedChild($0) }
    }

    /// Adds an array of children to the carrier and arranges them in view.
    /// - Parameter children: The nodes to add to the carrier.
    func addArrangedChildren(_ children: SKNode...) {
        children.forEach { self.addArrangedChild($0) }
    }

    private func getHorizontalOffset(of child: SKNode) -> CGPoint {
        let previousOffset = (_arrangedChildren.last?.frame.width ?? 0) / 2
        if previousOffset > 0 {
            let offset = previousOffset + (child.frame.width / 2) + spacing
            return .init(x: -offset, y: 0)
        }
        return .zero
    }

    private func getVerticalOffset(of child: SKNode) -> CGPoint {
        let previousOffset = (_arrangedChildren.last?.frame.height ?? 0) / 2
        if previousOffset > 0 {
            let offset = previousOffset + (child.frame.height / 2) + spacing
            return .init(x: 0, y: offset)
        }
        return .zero
    }
}
