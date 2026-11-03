//
//  LevelManager+Collision.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 3/11/26.
//

import Foundation

extension LevelManager {
    func updatePlayer(dt: TimeInterval) {
        // update the positions
        let soulUp = currentlyPressedKeys.contains("W")
        let soulLeft = currentlyPressedKeys.contains("A")
        let soulDown = currentlyPressedKeys.contains("S")
        let soulRight = currentlyPressedKeys.contains("D")

        let meatUp = currentlyPressedKeys.contains("Up")
        let meatLeft = currentlyPressedKeys.contains("Left")
        let meatDown = currentlyPressedKeys.contains("Down")
        let meatRight = currentlyPressedKeys.contains("Right")

        let distance = 500 * dt // 500pts/s

        // move players
        if let ghost = level.players[.ghost] {
            level.players[.ghost] = move(
                player: ghost,
                distance: distance,
                up: soulUp, down: soulDown, left: soulLeft, right: soulRight
            )
        }
        if let zombie = level.players[.zombie] {
            level.players[.zombie] = move(
                player: zombie,
                distance: distance,
                up: meatUp, down: meatDown, left: meatLeft, right: meatRight
            )
        }
        if let human = level.players[.human] {
            level.players[.human] = move(
                player: human,
                distance: distance,
                up: meatUp || soulUp,
                down: meatDown || soulDown,
                left: meatLeft || soulLeft,
                right: meatRight || soulRight
            )
        }

        // check for joining
        if let ghost = level.players[.ghost],
           let zombie = level.players[.zombie],
           ghost.intersects(other: zombie) {
            // when ghost and zombie touch => human!
            level.players[.human] = .init(
                frame: zombie.frame, // use zombie frame to avoid clipping into walls if they merge on a diagonal
                variant: .human
            )
            level.players.removeValue(forKey: .ghost)
            level.players.removeValue(forKey: .zombie)
        }

        // win condition checking
        if let human = level.players[.human], !level.tiles.contains(other: human) {
            print("You win!")
        }
    }

    func move(player: Player, distance: CGFloat, up: Bool, down: Bool, left: Bool, right: Bool) -> Player {
        let change = CGSize(
            width: (left ? -distance : 0) + (right ? distance : 0),
            height: (up ? -distance : 0) + (down ? distance : 0)
        )
        // ensure that horizontal movement works
        var candidate = player
        candidate.frame.origin.x += change.width
        if !validPosition(candidate: candidate) {
            // undo if not valid position
            candidate.frame.origin.x -= change.width
        }
        candidate.frame.origin.y += change.height
        if !validPosition(candidate: candidate) {
            // undo if not valid position
            candidate.frame.origin.y -= change.height
        }
        return candidate
    }

    func validPosition(candidate: Player) -> Bool {
        func canCollide(playerVariant: PlayerVariant, obstacleVariant: ObstacleVariant) -> Bool {
            switch playerVariant {
            case .zombie:
                switch obstacleVariant {
                case .wall: true
                case .ichor: false
                case .salt: true
                case .lava: true
                }
            case .ghost:
                switch obstacleVariant {
                case .wall: false
                case .ichor: true
                case .salt: true
                case .lava: true
                }
            case .human:
                switch obstacleVariant {
                case .wall: true
                case .ichor: true
                case .salt: false
                case .lava: true
                }
            }
        }

        // check obstacle collisions
        for obstacle in level.obstacles {
            if canCollide(playerVariant: candidate.variant, obstacleVariant: obstacle.variant),
               candidate.intersects(other: obstacle) {
                return false
            }
        }
        // for ghost and zombie, ensure it stays within level bounds
        if candidate.variant != .human, !level.tiles.contains(other: candidate) {
            return false
        }

        // passed all checks!
        return true
    }
}
