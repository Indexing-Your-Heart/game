//
//  FlowConfiguration.swift
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

struct FlowConfiguration: Codable {
    let stage: String
    let chapter: String
    let showTutorials: Bool?
}

extension FlowConfiguration {
    static func load(from resourceName: String) -> [FlowConfiguration]? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "json") else { return nil }
        let url = URL(filePath: path)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.allowsJSON5 = true
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? jsonDecoder.decode([FlowConfiguration].self, from: data)
    }
}
