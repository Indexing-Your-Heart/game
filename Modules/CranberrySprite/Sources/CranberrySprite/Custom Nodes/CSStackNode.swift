//
//  CSStackNode.swift
//
//
//  Created by Marquis Kurt on 11/22/22.
//

import SpriteKit

/// A node that arranges its children in a stack, either along the horizontal or vertical axis.
/// Ideally, this should behave similarly to a `UIStackView`.
public class CSStackNode: SKNode {
    /// An enumeration representing the various axes children nodes can be aligned on.
    public enum AlignmentAxis {
        case vertical, horizontal
    }

    /// The spacing between each node. Defaults to `0`.
    public var spacing: CGFloat = 0 {
        didSet { rearrangeChildren() }
    }

    /// The alignment axis the children nodes will be aligned to.
    public var alignmentAxis: AlignmentAxis {
        didSet { rearrangeChildren() }
    }
    private var arrangedChildren = [SKNode]()

    /// Creates a stack node in the scene and adds its children, arranging them.
    /// - Parameter arrangedChildren: The children nodes to be added to this node.
    /// - Parameter alignment: The alignment axis that the nodes will be aligned to. Defaults to `.vertical`.
    public init(arrangedChildren: [SKNode], with alignment: AlignmentAxis = .vertical) {
        self.arrangedChildren = []
        alignmentAxis = alignment
        super.init()
        self.addArrangedChildren(arrangedChildren, rearrange: true)
    }

    /// Creates a stack node with an alignment axis and predefined spacing.
    /// - Parameter alignment: The alignment axis that the nodes will be aligned to.
    /// - Parameter spacing: The spacing between children nodes.
    public init(alignment: AlignmentAxis, spacing: CGFloat) {
        alignmentAxis = alignment
        self.spacing = spacing
        super.init()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Adds a child to the stack node and rearranges the contents.
    /// - Parameter childNode: The child node to be added to the scene.
    /// - Parameter shouldRearrangeOnAddition: Whether to rearrange all children around the center point. Defaults to
    /// `false`.
    public func addArrangedChild(_ childNode: SKNode, rearrange shouldRearrangeOnAddition: Bool = false) {
        let offset = calculateOffsets(including: childNode)
        childNode.position = .init(x: childNode.position.x - offset.x, y: childNode.position.y - offset.y)
        addChild(childNode)
        arrangedChildren.append(childNode)
        if shouldRearrangeOnAddition {
            rearrangeChildren()
        }
    }

    /// Adds children nodes to the stack node and rearranges the contents.
    /// - Parameter children: The children nodes to be added to the scene.
    /// - Parameter shouldRearrangeOnAddition: Whether to rearrange all children around the center point. Defaults to
    /// `false`.
    public func addArrangedChildren(_ children: [SKNode], rearrange shouldRearrangeOnAddition: Bool = false) {
        children.forEach { addArrangedChild($0, rearrange: false) }
        if shouldRearrangeOnAddition {
            rearrangeChildren()
        }
    }

    private func calculateOffsets(including child: SKNode) -> CGPoint {
        let isVertical = (alignmentAxis == .vertical)
        let prevValue = isVertical ? arrangedChildren.last?.frame.height : arrangedChildren.last?.frame.width
        let currValue = isVertical ? child.frame.height : child.frame.width
        let offsetValue = calculateOffsetValue(from: prevValue, aligningWithValue: currValue)
        return isVertical ? CGPoint(x: 0, y: offsetValue) : CGPoint(x: offsetValue, y: 0)
    }

    private func calculateOffsetValue(
        from previousValue: CGFloat?,
        aligningWithValue currentValue: CGFloat
    ) -> CGFloat {
        let previousOffset = (previousValue ?? 0) / 2
        return previousOffset > 0 ? previousOffset + (currentValue / 2) + spacing : 0
    }

    private func rearrangeChildren() {
        let expectedWidth = arrangedChildren.map { $0.frame.width + spacing }.reduce(0.0, +) - spacing
        let expectedHeight = arrangedChildren.map { $0.frame.height + spacing }.reduce(0.0, +) - spacing

        switch alignmentAxis {
        case .vertical:
            let offsetFromHeight = expectedHeight / 2
            var currentPoint = CGPoint(x: 0, y: -offsetFromHeight)
            arrangedChildren.forEach { child in
                child.position = currentPoint
                currentPoint = CGPoint(x: 0, y: currentPoint.y + spacing + child.frame.height)
            }
        case .horizontal:
            let offsetFromWidth = expectedWidth / 2
            var currentPoint = CGPoint(x: -offsetFromWidth, y: 0)
            arrangedChildren.forEach { child in
                child.position = currentPoint
                currentPoint = CGPoint(x: currentPoint.x + spacing + child.frame.width, y: 0)
            }
        }
    }
}
