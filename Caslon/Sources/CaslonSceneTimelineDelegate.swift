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

/// A protocol that indicates an object is capable of iterating through a Jenson timeline.
public protocol CaslonSceneTimelineDelegate: AnyObject {
    /// The list of Jenson events that the delegate will iterate through.
    var timeline: [JensonEvent] { get set }

    /// A method called when an event is about to be displayed on screen.
    /// - Parameter event: The event that the timeline will play.
    func willDisplayNewEvent(event: JensonEvent)

    /// A method called when an event has finished displaying on screen.
    /// - Parameter event: The event that has been displayed.
    func didDisplayNewEvent(event: JensonEvent)
}

public extension CaslonSceneTimelineDelegate {
    /// Loads the next event in the timeline and informs the scene to update its contents.
    func next() {
        guard !timeline.isEmpty else { return }
        let event = timeline.removeFirst()
        willDisplayNewEvent(event: event)
        didDisplayNewEvent(event: event)
    }
}
