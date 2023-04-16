//
//  GameFlowConfiguration.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/7/22.
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

public struct CelestialFlowConfiguration: Codable {
    public let stage: String
    public let chapter: String
    public let showTutorials: Bool?

    public init(stage: String, chapter: String, showTutorials: Bool?) {
        self.stage = stage
        self.chapter = chapter
        self.showTutorials = showTutorials
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stage = try container.decode(String.self, forKey: .stage)
        chapter = try container.decode(String.self, forKey: .chapter)
        showTutorials = try container.decodeIfPresent(Bool.self, forKey: .showTutorials)
    }
}

public extension CelestialFlowConfiguration {
    static func load(from resourceName: String) -> [CelestialFlowConfiguration]? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else { return nil }
        let url = URL(filePath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.allowsJSON5 = true
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? jsonDecoder.decode([CelestialFlowConfiguration].self, from: data)
    }
}
