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
    var moveable: [MoveableObstacle]
    var tiles: TileMap

    init(name: String, replacements: [Character: MoveableObstacle] = [:], map: String) {
        let tileSize: CGSize = .init(width: 100, height: 100)
        let playerSize: CGSize = .init(width: 60, height: 60)
        let obstacleSize: CGSize = .init(width: 80, height: 80)

        self.name = name

        self.players = [:]
        self.obstacles = []
        self.moveable = []

        let lines = map.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n").map { $0.characters }
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
                case "#", "~", "*", "+":
                    let variant: ObstacleVariant = switch cell {
                    case "#": .wall
                    case "~": .ichor
                    case "*": .salt
                    case "+": .lava
                    default: fatalError("Internal inconsistency")
                    }

                    // determine if the obstacles to the top, bottom, left, and right are the same type.
                    let upSame = if rowNo > 0 { lines[rowNo-1][colNo] == cell } else { false }
                    let downSame = if rowNo < lines.count - 1 { lines[rowNo+1][colNo] == cell } else { false }
                    let leftSame = if colNo > 0 { row[colNo-1] == cell } else { false }
                    let rightSame = if colNo < row.count - 1 { row[colNo+1] == cell } else { false }

                    let dot = CGRect(center: cellFrame.center, size: obstacleSize)
                    // calculate the horizontal
                    if leftSame || rightSame {
                        let horizontalRect = CGRect(
                            minX: leftSame ? cellFrame.minX : dot.minX,
                            minY: dot.minY,
                            maxX: rightSame ? cellFrame.maxX : dot.maxX,
                            maxY: dot.maxY
                        )
                        obstacles.append(.init(frame: horizontalRect, variant: variant, orientation: .up))
                    }
                    // calculate the vertical
                    if upSame || downSame {
                        let verticalRect = CGRect(
                            minX: dot.minX,
                            minY: upSame ? cellFrame.minY : dot.minY,
                            maxX: dot.maxX,
                            maxY: downSame ? cellFrame.maxY : dot.maxY
                        )
                        obstacles.append(.init(frame: verticalRect, variant: variant, orientation: .left))
                    }

                    // if none, then its just a dot
                    if !(upSame || downSame || leftSame || rightSame) {
                        obstacles.append(.init(frame: dot, variant: variant, orientation: .up))
                    }
                default:
                    // check if it matches a known replacement, else continue loop
                    guard var replacement = replacements[cell] else { continue }
                    // add the replacement in
                    replacement.frame = cellFrame
                    moveable.append(replacement)
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

    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }

    var center: CGPoint {
        .init(x: midX, y: midY)
    }
}

extension StringProtocol {
    var characters: [Character] {
        self.map { $0 }
    }
}
