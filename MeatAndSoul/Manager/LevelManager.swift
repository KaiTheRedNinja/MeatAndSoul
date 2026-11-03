//
//  LevelManager.swift
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
            replacements: [
                "A": .init(linked: "A", frame: .zero, variant: .bridge, defaultClosed: true, isOpen: true),
                "B": .init(linked: "B", frame: .zero, variant: .bridge, defaultClosed: true, isOpen: false),
                "C": .init(linked: "C", frame: .zero, variant: .door, defaultClosed: true, isOpen: true),
                "D": .init(linked: "D", frame: .zero, variant: .door, defaultClosed: true, isOpen: false)
            ],
            map: """
            ++++++++++
            +~~~~~~  +
            +~G# AB  +
            +~~~~~~   
            +######  +
            +#Z~ CD  +
            +######  +
            ++++++++++
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
