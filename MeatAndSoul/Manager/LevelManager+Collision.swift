//
//  LevelManager+Collision.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 3/11/26.
//

import Foundation
import CoreGraphics

extension LevelManager {
    func updatePlayer(dt: TimeInterval) {
        // we only need to update if we're playing
        guard case .playing = level.levelState else { return }

        // update the positions
        let soulUp = keys.keyState("W").isDown
        let soulLeft = keys.keyState("A").isDown
        let soulDown = keys.keyState("S").isDown
        let soulRight = keys.keyState("D").isDown

        let meatUp = keys.keyState("Up").isDown
        let meatLeft = keys.keyState("Left").isDown
        let meatDown = keys.keyState("Down").isDown
        let meatRight = keys.keyState("Right").isDown

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

        // check for button collisions
        for (index, interactable) in level.interactables.enumerated() where interactable.variant == .button {
            let isPressed = level.players.values.contains(where: { $0.intersects(other: interactable) })
            var interactableCopy = interactable
            interactableCopy.active = isPressed
            // update the button
            level.interactables[index] = interactableCopy
        }

        // check for lever collisions
        for (index, interactable) in level.interactables.enumerated() where interactable.variant == .lever {
            let isTouching = level.players.values.contains(where: { $0.intersects(other: interactable) })
            var interactableCopy = interactable
            interactableCopy.playerTouching = isTouching
            // if it went from not touching to touching, flip the state
            if interactable.playerTouching == false && interactableCopy.playerTouching {
                interactableCopy.active = !interactableCopy.active
            }
            // update the button
            level.interactables[index] = interactableCopy
        }

        // get all interactable values
        var activeValues: [String: Bool] = [:]
        for interactable in level.interactables {
            // we OR them together
            activeValues[interactable.linked.id] = (activeValues[interactable.linked.id] ?? false) || interactable.active
        }
        // update them all at once
        for (index, movable) in level.moveables.enumerated() {
            guard let isActive = activeValues[movable.linked.id] else { continue }
            var movableCopy = movable
            movableCopy.isOpen = movable.defaultClosed ? isActive : !isActive
            level.moveables[index] = movableCopy
        }

        // win condition checking
        if let human = level.players[.human], !level.tiles.contains(other: human) {
            print("You win!")
            level.levelState = .finished
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
        let movement: SpriteOrientation? = if change == .zero { nil }
        else if change.width > 0 { .right }
        else if change.width < 0 { .left }
        else if change.height > 0 { .down }
        else if change.height < 0 { .up }
        else { nil }
        candidate.movementDirection = movement
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

        // get all areas where hitboxes are invalidated due to a movable obstacle
        let invalidatingRects: [CGRect] = level.moveables.compactMap { $0.currentBehaviour == .movementAllowed ? $0.frame : nil }

        // check obstacle collisions
        for obstacle in level.obstacles {
            let collisionRect = candidate.frame.intersection(obstacle.frame)
            if canCollide(playerVariant: candidate.variant, obstacleVariant: obstacle.variant), // can collide
               collisionRect != .null,                                                          // does collide
               !invalidatingRects.contains(where: { $0.contains(collisionRect) }) {             // collision is not invalidated
                return false
            }
        }
        // check moveable collisions
        for moveable in level.moveables {
            // we don't need to check if moveables are invalidated because they shouldn't overlap
            guard case let .obstacle(variant) = moveable.currentBehaviour else { continue }
            if canCollide(playerVariant: candidate.variant, obstacleVariant: variant),
               candidate.intersects(other: moveable) {
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
