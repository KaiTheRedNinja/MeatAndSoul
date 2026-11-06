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

    var keys: KeysState = .init()

    init(level: Level) {
        self.level = level
        self.levelBackup = level
    }

    static let test: LevelManager = .init(
        level: .init(
            name: "Testing",
            replacements: [
                "A": .init(obstacle: .ichor, movable: .init(linked: "A", frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),
//                "B": .init(movable: .init(linked: "B", frame: .zero, variant: .bridge, defaultClosed: true, isOpen: false)),
                "C": .init(obstacle: .wall, movable: .init(linked: "C", frame: .zero, variant: .door, orientation: .left, defaultClosed: true, isOpen: false)),
//                "D": .init(movable: .init(linked: "D", frame: .zero, variant: .door, defaultClosed: true, isOpen: false)),
                "E": .init(interactable: .init(linked: "A", frame: .zero, variant: .button, active: false, orientation: .up)),
                "F": .init(interactable: .init(linked: "C", frame: .zero, variant: .lever, active: false, orientation: .up))
            ],
            map: """
            ++++++++++
            +~~~~~~  +
            +~G#F A  +
            +~~~~~~   
            +######  +
            +#Z~E C  +
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

struct KeysState: Equatable {
    private var states: [String: KeyState]

    init() {
        self.states = [:]
    }

    enum KeyState {
        /// The key was just pressed between this tick and the previous
        case wasPressed
        /// The key is being pressed
        case pressed
        /// The key was just released between this tick and the previous
        case wasReleased
        /// The key is released (i.e. not pressed)
        case released

        var isDown: Bool {
            switch self {
            case .wasPressed, .pressed: true
            case .wasReleased, .released: false
            }
        }
    }

    mutating func update(forKeyEvent event: KeyEventInfo) {
        switch event.phase {
        case .up: states[event.physicalKeyName] = .wasReleased
        case .down:
            if !keyState(event.physicalKeyName).isDown {
                states[event.physicalKeyName] = .wasPressed
            }
        }
    }

    /// Turns all `wasPressed` into `pressed` and all `wasReleased` into `released`
    mutating func nextTick() {
        for (name, state) in states {
            switch state {
            case .wasPressed: states[name] = .pressed
            case .wasReleased: states[name] = .released
            default: continue
            }
        }
    }

    /// Returns the current state of the key
    func keyState(_ name: String) -> KeyState {
        states[name, default: .released]
    }
}
