//
//  PaintbrushStageConfiguration.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/30/22.
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

public struct PaintbrushStageConfiguration: Codable {
    public let stage: String
    public let metapuzzle: PaintbrushStageMetapuzzleConfiguration
    public let puzzles: [PaintbrushStagePuzzleConfiguration]
}

public struct PaintbrushStageMetapuzzleConfiguration: Codable {
    public let expectedResult: String
    public let palette: PaintbrushStagePaletteConfiguration
}

public struct PaintbrushStagePuzzleConfiguration: Codable {
    public let paintingName: String
    public let expectedResult: String
    public let palette: PaintbrushStagePaletteConfiguration
}

public struct PaintbrushStagePaletteConfiguration: Codable {
    public let panelColor: String
    public let panelLineColor: String
}

public extension PaintbrushStageConfiguration {
    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
