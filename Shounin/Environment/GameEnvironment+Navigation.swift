//
//  GameEnvironment+Navigation.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/14/22.
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

import CranberrySprite
import GameplayKit
import SKTiled
import SpriteKit

extension GameEnvironment: GameEnvironmentNavigationDelegate {
    func createGraph(in layer: SKTileLayer) {
        let newGraph = layer.initializeGraph(walkable: walkableTiles, obstacles: [], diagonalsAllowed: false)
        layer.graph = newGraph
#if DEBUG
        layer.debugDrawOptions = [.drawBounds, .drawGraph]
        layer.alpha = 0.1
#endif
    }

    func getWalkableNodes(from layer: SKTileLayer) {
        walkableTiles.append(contentsOf: layer.gatherWalkable())
    }

    func path(to coordinate: CGPoint) -> [GKGraphNode] {
        guard let player, let walkingLayer, let graph = walkingLayer.graph else { return [] }
        let start = player.getCoordinates(withRespectTo: walkingLayer)
        guard walkingLayer.isValid(coord: start), walkingLayer.isValid(coord: coordinate) else { return [] }

        if let start = graph.node(atGridPosition: start.toVec2),
           let end = graph.node(atGridPosition: coordinate.toVec2)
        {
            return start.findPath(to: end)
        }
        return []
    }

    func actions(with graphNodes: [GKGraphNode], speed: CGFloat = 1) -> [SKAction] {
        guard let nodes = graphNodes as? [GKGridGraphNode], let walkingLayer, let player else { return [] }
        var actions = [SKAction]()
        var currentPosition = player.position
        for node in nodes {
            let layerPoint = walkingLayer.pointForCoordinate(vec2: node.gridPosition)
            let nodePosition = walkingLayer.convert(layerPoint, to: self)
            let direction = direction(from: currentPosition, to: nodePosition)
            logger.debug("Move \(currentPosition) -> \(nodePosition) [\(direction)]")

            var delta = 1.0
            switch direction {
            case .left, .right:
                delta = nodePosition.x - currentPosition.x
            case .up, .down:
                delta = nodePosition.y - currentPosition.y
            default:
                break
            }

            let moveSpeed = abs(delta / 16) * speed

            actions.append(contentsOf: [
                SKAction.run { [weak self] in
                    self?.player?.move(in: direction)
                },
                SKAction.move(to: nodePosition, duration: 0.25 * moveSpeed)
            ])
            currentPosition = nodePosition
        }
        actions.append(
            SKAction.run { [weak self] in
                self?.player?.stopMoving()
            }
        )
        return actions
    }

    private func direction(from start: CGPoint, to end: CGPoint) -> GamePlayer.Direction {
        let deltaX = end.x - start.x
        let deltaY = end.y - start.y
        if deltaX != 0 {
            return deltaX > 0 ? GamePlayer.Direction.right : GamePlayer.Direction.left
        } else if deltaY != 0 {
            return deltaY > 0 ? GamePlayer.Direction.up : GamePlayer.Direction.down
        }
        return GamePlayer.Direction.stop
    }
}
