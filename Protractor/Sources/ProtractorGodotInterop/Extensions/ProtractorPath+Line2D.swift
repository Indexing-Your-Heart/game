//
//  File.swift
//  
//
//  Created by Marquis Kurt on 5/25/23.
//

import Foundation
import Protractor
import SwiftGodot

extension ProtractorPath {
    public init(line: Line2D) {
        self.init(points: line.points.map(ProtractorPoint.init))
    }
}
