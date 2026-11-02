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

        let soulChange = CGSize(
            width: (soulLeft ? -distance : 0) + (soulRight ? distance : 0),
            height: (soulUp ? -distance : 0) + (soulDown ? distance : 0)
        )
        let meatChange = CGSize(
            width: (meatLeft ? -distance : 0) + (meatRight ? distance : 0),
            height: (meatUp ? -distance : 0) + (meatDown ? distance : 0)
        )
        let humanChange = CGSize(
            width: ((meatLeft || soulLeft) ? -distance : 0) + ((meatRight || soulRight) ? distance : 0),
            height: ((meatUp || soulUp) ? -distance : 0) + ((meatDown || soulDown) ? distance : 0)
        )
        if var ghost = level.players[.ghost] {
            ghost.frame.origin.x += soulChange.width
            ghost.frame.origin.y += soulChange.height
            level.players[.ghost] = ghost
        }
        if var zombie = level.players[.zombie] {
            zombie.frame.origin.x += meatChange.width
            zombie.frame.origin.y += meatChange.height
            level.players[.zombie] = zombie
        }
        if var human = level.players[.human] {
            human.frame.origin.x += humanChange.width
            human.frame.origin.y += humanChange.height
            level.players[.human] = human
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
