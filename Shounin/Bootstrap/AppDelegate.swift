//
//  AppDelegate.swift
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

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import GameKit

// MARK: - General App Delegation

class AppDelegate: NSObject {
    static var observedState = GameEnvironmentState()

    func setUpGameCenterAccessPoint() {
        GKAccessPoint.shared.location = .bottomTrailing
        GKAccessPoint.shared.showHighlights = true
    }
}

// MARK: - Mac App Delegate Adaptor

#if os(macOS)
extension AppDelegate: NSApplicationDelegate {
    // Authenticate with Game Center.
    func applicationDidFinishLaunching(_: Notification) {
        if let useGC = Bundle.main.gameCenterEnabled, useGC {
            DispatchQueue.main.async {
                GKLocalPlayer.local.authenticateHandler = { loginSheet, error in
                    if let loginSheet {
                        NSApplication.shared.keyWindow?.contentViewController?.presentAsSheet(loginSheet)
                    }
                    guard error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                }
            }
        }
    }

    // Forcibly set the aspect ratio to 16:10. This prevents awkward resizing.
    func applicationDidBecomeActive(_: Notification) {
        NSApplication.shared.keyWindow?.aspectRatio = .init(width: 16, height: 10)
        if let useGC = Bundle.main.gameCenterEnabled, useGC {
            setUpGameCenterAccessPoint()
        }
    }

    // Terminates after the window is closed, which is intended behavior.
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}
#endif

// MARK: - iOS App Delegate Adaptor

#if os(iOS)
extension AppDelegate: UIApplicationDelegate {
    /// Retrieves the key window of the primary scene.
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?.windows
            .first { $0.isKeyWindow }
    }

    // Authenticate with Game Center.
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let useGC = Bundle.main.gameCenterEnabled, useGC {
            DispatchQueue.main.async {
                GKLocalPlayer.local.authenticateHandler = { loginSheet, error in
                    if let loginSheet {
                        AppDelegate.keyWindow?.rootViewController?.present(loginSheet, animated: true)
                    }
                    guard error == nil else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                }
            }
            setUpGameCenterAccessPoint()
        }
        return true
    }
}
#endif
