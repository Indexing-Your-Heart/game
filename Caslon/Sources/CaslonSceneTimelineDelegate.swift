//
//  CaslonSceneDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/4/22.
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
import JensonKit

public protocol CaslonSceneTimelineDelegate: AnyObject {
    var timeline: [JensonEvent] { get set }
    func next()
    func willDisplayNewEvent(event: JensonEvent)
    func didDisplayNewEvent(event: JensonEvent)
}

extension CaslonSceneTimelineDelegate {
    func next() {
        guard !timeline.isEmpty else { return }
        let event = timeline.removeFirst()
        willDisplayNewEvent(event: event)
        didDisplayNewEvent(event: event)
    }
}
