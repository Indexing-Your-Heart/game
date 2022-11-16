//
//  GameEnvironmentState.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 10/6/22.
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
import Paintbrush

/// A class that contains a game environment state.
class GameEnvironmentState {
    /// The previous game environment the player has played in.
    var previousEnvironment: GameEnvironment?

    /// The solve status of the previous puzzle.
    var previousPuzzleState: PaintbrushSolveState?

    /// The name of the puzzle to trigger in Paintbrush.
    var puzzleTriggerName: String?
}
