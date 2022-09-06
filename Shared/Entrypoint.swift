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
    @NSApplicationDelegateAdaptor(MacAppDelegateAdaptor.self) var delegate
#else
    @UIApplicationDelegateAdaptor(MobileAppDelegateAdaptor.self) var delegate
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

// MARK: - Mac App Delegate Adaptor

#if os(macOS)
class MacAppDelegateAdaptor: NSObject, NSApplicationDelegate {
    func applicationDidBecomeActive(_: Notification) {
        // Forcibly set the aspect ratio to 16:10. This prevents awkward resizing.
        NSApplication.shared.keyWindow?.aspectRatio = .init(width: 16, height: 10)
    }

    // Terminates after the window is closed, which is intended behavior.
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}
#endif

// MARK: - iOS App Delegate Adaptor

#if os(iOS)
class MobileAppDelegateAdaptor: NSObject, UIApplicationDelegate {}
#endif
