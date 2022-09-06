//
//  Entrypoint.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 9/1/22.
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
import SwiftUI

// MARK: - Entrypoint

@main
struct IndexingYourHeartApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
#else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
#endif

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
#if os(macOS)
                .frame(minWidth: 912, minHeight: 570)
#endif
        }
    }
}
