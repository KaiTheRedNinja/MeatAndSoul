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
        for tile in level.tiles.tiles.values {
            if willCollide(playerVariant: candidate.variant, tileVariant: tile.variant),
               candidate.intersects(other: tile) {
                return false
            }
        }
        return true
    }

    func willCollide(playerVariant: PlayerVariant, tileVariant: GroundTileVariant) -> Bool {
        switch playerVariant {
        case .zombie:
            switch tileVariant {
            case .dirt: false
            case .wall: true
            case .ichor: false
            case .salt: true
            case .lava: true
            }
        case .ghost:
            switch tileVariant {
            case .dirt: false
            case .wall: false
            case .ichor: true
            case .salt: true
            case .lava: true
            }
        case .human:
            switch tileVariant {
            case .dirt: false
            case .wall: true
            case .ichor: true
            case .salt: false
            case .lava: true
            }
        }
    }
}

struct Level {
    var name: String
    var players: [PlayerVariant: Player]
    var tiles: TileMap

    init(name: String, map: String) {
        let tileSize: CGSize = .init(width: 100, height: 100)
        let playerSize: CGSize = .init(width: 60, height: 60)

        self.name = name

        self.players = [:]

        let lines = map.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n")
        var tileMap: [[GroundTile]] = []
        for (rowNo, row) in lines.enumerated() {
            var rowTiles: [GroundTile] = []

            for (colNo, cell) in row.enumerated() {
                let cellFrame = CGRect(
                    x: tileSize.width * CGFloat(colNo),
                    y: tileSize.height * CGFloat(rowNo),
                    width: tileSize.width,
                    height: tileSize.height
                )

                switch cell {
                case "G":
                    players[.ghost] = .init(frame: .init(center: cellFrame.center, size: playerSize), variant: .ghost)
                    rowTiles.append(.init(frame: .zero, variant: .dirt))
                case "Z":
                    players[.zombie] = .init(frame: .init(center: cellFrame.center, size: playerSize), variant: .zombie)
                    rowTiles.append(.init(frame: .zero, variant: .dirt))
                case "#":
                    rowTiles.append(.init(frame: .zero, variant: .wall))
                case "~":
                    rowTiles.append(.init(frame: .zero, variant: .ichor))
                case "*":
                    rowTiles.append(.init(frame: .zero, variant: .salt))
                case "+":
                    rowTiles.append(.init(frame: .zero, variant: .lava))
                default:
                    // dirt
                    rowTiles.append(.init(frame: .zero, variant: .dirt))
                }
            }

            tileMap.append(rowTiles)
        }
        self.tiles = .init(tileMap: tileMap, tileSize: tileSize)
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(
            origin: .init(x: center.x - size.width/2, y: center.y - size.height/2),
            size: size
        )
    }

    var center: CGPoint {
        .init(x: midX, y: midY)
    }
}
