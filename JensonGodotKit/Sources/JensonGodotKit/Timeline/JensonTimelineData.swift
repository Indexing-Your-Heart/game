//
//  JensonTimelineData.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/19/23.
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

enum JensonGodotTimelineState {
    case initial
    case loaded
    case started
    case playing
    case ended

    static var unsafeRefreshStates: [JensonGodotTimelineState] {
        [.initial, .loaded, .ended]
    }
}

enum JensonGodotAnimationName: String {
    case startTimeline = "start_timeline"
    case speech

    var stringName: StringName {
        StringName(stringLiteral: rawValue)
    }
}

enum JensonGodotChildPath: String {
    case animationPlayer = "AnimationPlayer"
    case background = "Background"
    case choiceMenu = "Choice Menu"
    case leftSpeaker = "Multi Speakers/Left Speaker"
    case rightSpeaker = "Multi Speakers/Right Speaker"
    case singleSpeaker = "Single Speaker"
}

enum JensonGodotImageRefreshPriorityLayer: Int {
    case background = -1
    case speakerSingle = 0
    case speakerLeft = 1
    case speakerRight = 2
    case unknown = -999
}
