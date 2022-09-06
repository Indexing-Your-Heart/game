//
//  FontFamily.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/6/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import SwiftUI

extension Font {
    /// Returns the Salmon font family equivalent of a font style, matching the style guide.
    /// - Parameter style: The SwiftUI font style to be matched against.
    static func salmonEquivalent(for style: Font.TextStyle) -> Font {
        switch style {
        case .largeTitle, .title:
            return .custom("Salmon Sans 9 Bold", size: 36)
        case .title2:
            return .custom("Salmon Sans 9 Regular", size: 24)
        case .footnote:
            return .custom("Salmon Serif 9 Regular", size: 9)
        default:
            return .custom("Salmon Sans 9 Regular", size: 18)
        }
    }

    /// Returns the Salmon monospaced font, matching the style guide.
    static func salmonMonospaced() -> Font {
        .custom("Salmon Mono 9 Regular", size: 18)
    }
}

/// Debugging view used to display custom fonts.
struct SalmonFontFamily_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("example.hello_world")
                .font(.salmonEquivalent(for: .largeTitle))
            Text("example.hello_world")
                .font(.salmonEquivalent(for: .title2))
            Text("example.hello_world")
                .font(.salmonEquivalent(for: .body))
            Text("example.hello_world")
                .font(.salmonEquivalent(for: .footnote))
            Text("example.hello_world")
                .font(.salmonMonospaced())
        }
        .padding()
    }
}
