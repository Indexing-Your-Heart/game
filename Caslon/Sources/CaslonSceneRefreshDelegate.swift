//
//  CaslonSceneRefreshDelegate.swift
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

/// A protocol that indicates an object can listen to refresh events triggered by a Jenson event.
public protocol CaslonSceneRefreshDelegate: AnyObject {
    /// A method called when the refresh event is about to occur.
    ///
    /// To trigger a refresh event, call ``refreshContents(with:)``.
    /// - Parameter kind: The kind of content that will be refreshed.
    /// - Parameter resourceName: The name of the resource in the asset catalog that the event will replace the content
    /// with.
    /// - Parameter priority: The priority layer that the refresh event will target.
    func willRefreshContents(of kind: JensonRefreshContent.Kind, to resourceName: String, with priority: Int?)

    /// A method called when the refresh event had finished refreshing contents.
    func didRefreshContents()
}

public extension CaslonSceneRefreshDelegate {
    /// Triggers a refresh event.
    /// - Parameter trigger: The refresh event trigger that will be used to update the scene.
    func refreshContents(with trigger: JensonRefreshContent) {
        willRefreshContents(of: trigger.kind, to: trigger.resourceName, with: trigger.priority)
        didRefreshContents()
    }
}
