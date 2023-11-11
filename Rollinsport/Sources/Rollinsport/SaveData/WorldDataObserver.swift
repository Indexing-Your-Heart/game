//
//  WorldDataObserver.swift
//  Indexing Your Heart
//
//  Created by Marquis Kurt on 11/11/23.
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

@NativeHandleDiscarding
class WorldDataObserver: Node {
    static var shared = WorldDataObserver()

    required init() {
        super.init()
    }

    func saveData(blob: WorldDataBlob) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(blob)
            let stringContent = String(data: data, encoding: .utf8)

            guard let file = FileAccess.open(path: "user://savedata", flags: .write) else {
                LibRollinsport.logger.error("Save data is either missing, or it cannot be opened for writing.")
                return
            }
            file.storeString(stringContent ?? "{}")
            file.close()
        } catch {
            LibRollinsport.logger.error("Failed to save data: \(error.localizedDescription)")
        }
    }

    func loadData(into world: RollinsportWorld2D) {
        let file = FileAccess.open(path: "user://savedata", flags: .read)
        let stringContent = file?.getAsText() ?? "{}"
        guard let data = stringContent.data(using: .utf8) else { return }
        let decoder = JSONDecoder()
        do {
            let saveData = try decoder.decode(WorldDataBlob.self, from: data)
            world.player?.globalPosition = Vector2(codablePosition: saveData.playerPosition)
            world.readScripts = saveData.readScripts
            world.solvedPuzzles = saveData.solvedPuzzles
        } catch {
            LibRollinsport.logger.error("Failed to load data: \(error.localizedDescription)")
        }
    }
}
