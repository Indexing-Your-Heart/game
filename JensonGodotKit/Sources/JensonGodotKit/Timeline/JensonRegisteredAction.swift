//
//  JensonRegisteredAction.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 6/3/23.
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

enum JensonRegisteredAction: String {
    case timelineNext = "timeline_next"
}

extension Input {
    static func isActionPressed(action: JensonRegisteredAction) -> Bool {
        Input.isActionPressed(action: StringName(action.rawValue))
    }
}
