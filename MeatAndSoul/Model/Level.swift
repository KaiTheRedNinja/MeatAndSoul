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
    var moveables: [MoveableObstacle]
    var interactables: [Interactable]
    var tiles: TileMap

    init(name: String, replacements: [Character: TileReplacement] = [:], map: String) {
        let tileSize: CGSize = .init(width: 100, height: 100)
        let playerSize: CGSize = .init(width: 60, height: 60)
        let obstacleSize: CGSize = .init(width: 60, height: 60)

        self.name = name

        self.players = [:]
        self.obstacles = []
        self.moveables = []
        self.interactables = []

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

                var obstacle: ObstacleVariant?
                var movable: MoveableObstacle?
                var interactable: Interactable?

                if let replacement = replacements[cell] {
                    obstacle = replacement.obstacle
                    movable = replacement.movable
                    interactable = replacement.interactable
                }

                switch cell {
                case "G":
                    players[.ghost] = .init(frame: .init(center: cellFrame.center, size: playerSize), variant: .ghost)
                case "Z":
                    players[.zombie] = .init(frame: .init(center: cellFrame.center, size: playerSize), variant: .zombie)
                case "#", "~", "*", "+":
                    obstacle = switch cell {
                    case "#": .wall
                    case "~": .ichor
                    case "*": .salt
                    case "+": .lava
                    default: fatalError("Internal inconsistency")
                    }
                default: break // dont do anything in particular here
                }

                if let obstacle {
                    // determine if the obstacles to the top, bottom, left, and right are the same type.
                    let upSame = if rowNo > 0 { lines[rowNo-1][colNo] == cell } else { false }
                    let downSame = if rowNo < lines.count - 1 { lines[rowNo+1][colNo] == cell } else { false }
                    let leftSame = if colNo > 0 { row[colNo-1] == cell } else { false }
                    let rightSame = if colNo < row.count - 1 { row[colNo+1] == cell } else { false }

                    let joints: Set<SpriteOrientation> = .init(map: [
                        .up: upSame,
                        .down: downSame,
                        .left: leftSame,
                        .right: rightSame
                    ])

                    let dot = CGRect(center: cellFrame.center, size: obstacleSize)
                    // calculate the horizontal
                    if leftSame || rightSame {
                        let horizontalRect = CGRect(
                            minX: leftSame ? cellFrame.minX : dot.minX,
                            minY: dot.minY,
                            maxX: rightSame ? cellFrame.maxX : dot.maxX,
                            maxY: dot.maxY
                        )
                        obstacles.append(.init(frame: horizontalRect, variant: obstacle, orientation: .up, joints: joints))
                    }
                    // calculate the vertical
                    if upSame || downSame {
                        let verticalRect = CGRect(
                            minX: dot.minX,
                            minY: upSame ? cellFrame.minY : dot.minY,
                            maxX: dot.maxX,
                            maxY: downSame ? cellFrame.maxY : dot.maxY
                        )
                        obstacles.append(.init(frame: verticalRect, variant: obstacle, orientation: .left, joints: joints))
                    }

                    // if none, then its just a dot
                    if !(upSame || downSame || leftSame || rightSame) {
                        obstacles.append(.init(frame: dot, variant: obstacle, orientation: .up, joints: joints))
                    }
                }

                if var movable {
                    movable.frame = cellFrame
                    self.moveables.append(movable)
                }
                if var interactable {
                    interactable.frame = CGRect(center: cellFrame.center, size: obstacleSize)
                    self.interactables.append(interactable)
                }
            }

            tileMap.append(rowTiles)
        }
        self.tiles = .init(tileMap: tileMap, tileSize: tileSize)
    }
}

struct TileReplacement {
    var obstacle: ObstacleVariant?
    var movable: MoveableObstacle?
    var interactable: Interactable?
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

extension Set {
    init(map: [Element: Bool]) {
        self = Set(map.compactMap { $0.value ? $0.key : nil })
    }
}
