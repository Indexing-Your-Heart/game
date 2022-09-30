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

struct PaintbrushStageConfiguration: Codable {
    let stage: String
    let metapuzzle: PaintbrushStageMetapuzzleConfiguration
    let puzzles: [PaintbrushStagePuzzleConfiguration]
}

struct PaintbrushStageMetapuzzleConfiguration: Codable {
    let expectedResult: String
    let palette: PaintbrushStagePaletteConfiguration
}

struct PaintbrushStagePuzzleConfiguration: Codable {
    let paintingName: String
    let expectedResult: String
    let palette: PaintbrushStagePaletteConfiguration
}

struct PaintbrushStagePaletteConfiguration: Codable {
    let panelColor: String
    let panelLineColor: String
}

extension PaintbrushStageConfiguration {
    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
