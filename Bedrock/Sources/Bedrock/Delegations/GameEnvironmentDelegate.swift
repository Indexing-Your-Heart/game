//
//  GameEnvironmentDelegate.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/15/22.
//
//  This file is part of Indexing Your Heart.
//
//  Indexing Your Heart is non-violent software: you can use, redistribute, and/or modify it under the terms of the
//  CNPLv7+ as found in the LICENSE file in the source code root directory or at
//  <https://git.pixie.town/thufie/npl-builder>.
//
//  Indexing Your Heart comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.
//

import Foundation

/// The delegate responsible for communicating with the systems for movement and pathfinding.
public typealias GameEnvironmentMovementDelegate = GameEnvironmentTutorialDelegate & GameEnvironmentNavigationDelegate

/// The delegate responsible for communicating with the game's internal subsystems.
public typealias GameEnvironmentSubsystemDelegate = GameEnvironmentCaslonDelegate & GameEnvironmentPuzzleDelegate

/// The primary delegate responsible for communicating with all the game's systems, including movement and any
/// subsystem therein.
public typealias GameEnvironmentDelegate = GameEnvironmentMovementDelegate & GameEnvironmentSubsystemDelegate
