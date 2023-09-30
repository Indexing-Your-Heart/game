//
//  DefaultStringInterpolation+Indented.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/24/23.
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

// Original: https://gist.github.com/AnthonyMDev/08101004927a0e132f47875e36199121
// Thanks @AnthonyMDev
extension DefaultStringInterpolation {
    mutating func appendInterpolation<T>(indented string: T) {
        // swiftlint:disable:next compiler_protocol_init
        let indent = String(stringInterpolation: self).reversed().prefix { " \t".contains($0) }
        let root = String(describing: string)
        appendLiteral(
            indent.isEmpty ? root: root.split(separator: "\n", omittingEmptySubsequences: false)
                .joined(separator: "\n" + indent)
        )
    }
}
