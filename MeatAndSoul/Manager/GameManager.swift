//
//  GameManager.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

@Observable
class LevelManager {
    var level: Level
    /// Copied back to `level` upon reset
    var levelBackup: Level

    var currentlyPressedKeys: Set<String> = []

    init(level: Level) {
        self.level = level
        self.levelBackup = level
    }

    func update(forKeyEvent event: KeyEventInfo) {
        switch event.phase {
        case .up: currentlyPressedKeys.remove(event.physicalKeyName)
        case .down: currentlyPressedKeys.insert(event.physicalKeyName)
        }
    }

    static let test: LevelManager = .init(
        level: .init(
            name: "Testing",
            map: """
            +++++++++
            +~~~~~  +
            +~G  #  +
            +~~~~~   
            +#####  +
            +#Z  ~  +
            +#####  +
            +++++++++
            """
        )
    )

    func tick(dt: TimeInterval) {
        updatePlayer(dt: dt)
    }

    func restart() {
        level = levelBackup
    }
}
