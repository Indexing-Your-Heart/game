//
//  RollinsportApplicationDelegator.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 18/11/23.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

#if canImport(UIKit)
import UIKit

// Since Godot doesn't have a means for using a custom `UIApplicationDelegate` in our game, the game will instead listen
// for the UI events manually to allow others to better handle these events, such as saving a file when entering the
// background.

/// An application delegator that listens for UIKit app lifecycle events.
///
/// Since Godot doesn't have a means for using a custom `UIApplicationDelegate` in our game, the game will instead
/// listen for the UI events manually to allow others to better handle these events, such as saving a file when
/// entering the background.
///
/// Whenever a lifecycle event such as `UIApplication.didBecomeActiveNotification` is observed, the delegator will send
/// a notification to the ``RollinsportMessageBus`` with that lifecycle event on the main thread, asynchronously.
class RollinsportApplicationDelegator {
    init() {
        self.subscribe(#selector(applicationBecameActive), to: UIApplication.didBecomeActiveNotification)
        self.subscribe(#selector(applicationWillBecomeInactive), to: UIApplication.willResignActiveNotification)
        self.subscribe(#selector(applicationEntersForeground), to: UIApplication.willEnterForegroundNotification)
        self.subscribe(#selector(appEnteredBackground), to: UIApplication.didEnterBackgroundNotification)
    }

    private func subscribe(_ selector: Selector, to name: NSNotification.Name) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    private func unsubscribe(from name: NSNotification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    @objc private func applicationBecameActive() throws {
        LibRollinsport.logger.debug("App has become active.")
        DispatchQueue.main.async {
            try? RollinsportMessageBus.shared.notify(.appBecameActive)
        }
    }

    @objc private func applicationWillBecomeInactive() throws {
        LibRollinsport.logger.debug("App is about to become inactive.")
        DispatchQueue.main.async {
            try? RollinsportMessageBus.shared.notify(.appWillBecomeInactive)
        }
    }

    @objc private func applicationEntersForeground() throws {
        LibRollinsport.logger.debug("App is entering the foreground.")
        DispatchQueue.main.async {
            try? RollinsportMessageBus.shared.notify(.appWillEnterForeground)
        }
    }

    @objc private func appEnteredBackground() throws {
        LibRollinsport.logger.debug("App has entered the background.")
        DispatchQueue.main.async {
            try? RollinsportMessageBus.shared.notify(.appEnteredBackground)
        }
    }
}
#endif
