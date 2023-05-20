//
//  ProtractorPath.swift
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

import SwiftGodot
import Foundation

/// A struct that represents a path of points.
public struct ProtractorPath {
    /// A number that represents the minimum number of points needed to perform a successful resampling. This value is
    /// currently set to 16 points.
    public static let minimumPointsNeededForResampling = 16

    public var points: [ProtractorPoint]

    public init(points: [ProtractorPoint]) {
        self.points = points
    }
}

extension ProtractorPath {
    public init(line: Line2D) {
        self.points = line.points.map(ProtractorPoint.init)
    }
}

extension ProtractorPath: ProtractorPathConvertible {
    public typealias Point = ProtractorPoint

    public var centroid: ProtractorPoint {
        var centroid = ProtractorPoint.zero
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
            distance += ProtractorPoint.distance(from: points[idx - 1], to: points[idx])
        }
        return distance
    }

    public func resampled(count: Int) -> ProtractorPath {
        guard points.count >= ProtractorPath.minimumPointsNeededForResampling else { return self }
        var points = points
        let avgStep = length / Double(count - 1)
        var totalDistance = 0.0
        var newPoints = [points[0]]
        var idx = 1
        while idx < points.count {
            let stepDistance = ProtractorPoint.distance(from: points[idx - 1], to: points[idx])
            if (totalDistance + stepDistance) < avgStep {
                totalDistance += stepDistance
                idx += 1
                continue
            }
            let delta = ((avgStep - totalDistance) / stepDistance)
            let newX = points[idx - 1].x + delta * (points[idx].x - points[idx - 1].x)
            let newY = points[idx - 1].y + delta * (points[idx].y - points[idx - 1].y)
            let newPoint = ProtractorPoint(x: newX, y: newY)
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
