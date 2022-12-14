//
//  PaintbrushPointPath.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/2/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import CoreGraphics
import Foundation

/// A struct that represents a path of points.
public struct PaintbrushPointPath {
    public var points: [PaintbrushPoint]

    public init(points: [PaintbrushPoint]) {
        self.points = points
    }
}

extension PaintbrushPointPath: ProtractorPathConvertible {
    public typealias Point = PaintbrushPoint

    public var centroid: PaintbrushPoint {
        var centroid = PaintbrushPoint.zero
        for point in points {
            centroid.x += point.x
            centroid.y += point.y
        }
        centroid.x /= count
        centroid.y /= count
        return centroid
    }

    public var count: Double {
        Double(points.count)
    }

    public var indicativeAngle: Double {
        guard let first = points.first else { return 0.0 }
        return atan2(centroid.y - first.y, centroid.x - first.x)
    }

    public var length: Double {
        var distance = 0.0
        for idx in 1 ..< points.count {
            distance += PaintbrushPoint.distance(from: points[idx - 1], to: points[idx])
        }
        return distance
    }

    public func resampled(count: Int) -> PaintbrushPointPath {
        var points = points
        let avgStep = length / Double(count - 1)
        var totalDistance = 0.0
        var newPoints = [points[0]]
        var idx = 1
        while idx < points.count {
            let stepDistance = PaintbrushPoint.distance(from: points[idx - 1], to: points[idx])
            if (totalDistance + stepDistance) < avgStep {
                totalDistance += stepDistance
                idx += 1
                continue
            }
            let delta = ((avgStep - totalDistance) / stepDistance)
            let newX = points[idx - 1].x + delta * (points[idx].x - points[idx - 1].x)
            let newY = points[idx - 1].y + delta * (points[idx].y - points[idx - 1].y)
            let newPoint = PaintbrushPoint(x: newX, y: newY)
            newPoints.append(newPoint)
            points.insert(newPoint, at: idx)
            totalDistance = 0
            idx += 1
        }

        if newPoints.count == (count - 1), let finalPoint = points.last {
            newPoints.append(finalPoint)
        }

        return Self(points: newPoints)
    }

    public func vectorized(accountsForOrientation orientationSensitive: Bool) -> [Double] {
        let translatedPoints = points.map { $0.translated(by: centroid) }
        var delta = -indicativeAngle
        if orientationSensitive {
            let base = (Double.pi / 4) * floor((indicativeAngle + Double.pi / 8) / (Double.pi / 4))
            delta = base - indicativeAngle
        }
        var vectorizedPoints = [Double]()
        var sum = 0.0
        for point in translatedPoints {
            let newX = point.x * cos(delta) - point.y * sin(delta)
            let newY = point.y * cos(delta) - point.x * sin(delta)
            vectorizedPoints.append(contentsOf: [newX, newY])
            sum += (pow(newX, 2) + pow(newY, 2))
        }
        return vectorizedPoints.map { $0 / sqrt(sum) }
    }
}
