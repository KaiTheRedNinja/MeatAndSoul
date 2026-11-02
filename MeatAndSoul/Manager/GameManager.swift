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

    init(level: Level) {
        self.level = level
        self.levelBackup = level
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

        let lines = map.split(separator: "\n")
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
