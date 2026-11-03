//
//  Level.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 3/11/26.
//

import SwiftUI

struct Level {
    var name: String
    var players: [PlayerVariant: Player]
    var obstacles: [Obstacle]
    var tiles: TileMap

    init(name: String, map: String) {
        let tileSize: CGSize = .init(width: 100, height: 100)
        let playerSize: CGSize = .init(width: 60, height: 60)
        let obstacleSize: CGSize = .init(width: 80, height: 80)

        self.name = name

        self.players = [:]
        self.obstacles = []

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

                rowTiles.append(.init(frame: cellFrame, variant: .dirt))

                switch cell {
                case "G":
                    players[.ghost] = .init(frame: .init(center: cellFrame.center, size: playerSize), variant: .ghost)
                case "Z":
                    players[.zombie] = .init(frame: .init(center: cellFrame.center, size: playerSize), variant: .zombie)
                case "#":
                    obstacles.append(.init(frame: .init(center: cellFrame.center, size: obstacleSize), variant: .wall))
                case "~":
                    obstacles.append(.init(frame: .init(center: cellFrame.center, size: obstacleSize), variant: .ichor))
                case "*":
                    obstacles.append(.init(frame: .init(center: cellFrame.center, size: obstacleSize), variant: .salt))
                case "+":
                    obstacles.append(.init(frame: .init(center: cellFrame.center, size: obstacleSize), variant: .lava))
                default:
                    break // do nothing
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
