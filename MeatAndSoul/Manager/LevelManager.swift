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
