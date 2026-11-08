//
//  GroundTile.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

struct GroundTile: Sprite {
    var frame: CGRect
    var variant: GroundTileVariant
}

enum GroundTileVariant {
    case dirt
}

struct TileMap: Sprite {
    /// The number of rows in the map, i.e. vertical height
    var rows: Int
    /// The number of columns in the map, i.e. horizontal width
    var cols: Int
    /// The tiles. Key is row/col, value is tile
    var tiles: [TileAddress: GroundTile]
    /// All the tile addresses
    var addresses: [TileAddress]
    /// The size of a single tile
    var tileSize: CGSize
    /// The frame of the whole map, positioned at the origin
    var frame: CGRect {
        .init(
            origin: .zero,
            size: .init(
                width: tileSize.width * CGFloat(cols),
                height: tileSize.height * CGFloat(rows)
            )
        )
    }

    init(tileMap: [[GroundTile]], tileSize: CGSize?) {
        rows = 0
        cols = 0
        tiles = [:]
        addresses = []
        self.tileSize = tileSize ?? .zero

        guard let firstRow = tileMap.first, let firstTile = firstRow.first else {
            return
        }
        let rows = tileMap.count
        let cols = firstRow.count

        let size = tileSize ?? firstTile.frame.size
        var tiles: [TileAddress: GroundTile] = [:]
        for rowNo in 0..<rows {
            let row = tileMap[rowNo]
            guard row.count == cols else {
                print("ERROR: Tile map not rectangular!")
                return
            }

            for colNo in 0..<cols {
                let cell = row[colNo]
                addresses.append(.init(row: rowNo, col: colNo))
                tiles[.init(row: rowNo, col: colNo)] = .init(
                    frame: .init(
                        x: size.width * CGFloat(colNo),
                        y: size.height * CGFloat(rowNo),
                        width: size.width,
                        height: size.height
                    ),
                    variant: cell.variant
                )
            }
        }

        self.rows = rows
        self.cols = cols
        self.tiles = tiles
        self.tileSize = size
    }

    struct TileAddress: Hashable, Identifiable {
        var id: String { "\(row)_\(col)" }

        var row: Int
        var col: Int
    }
}

struct GroundTileView: View {
    var tile: GroundTile

    var body: some View {
        SpriteRender(sprite: tile) { size, _ in
            switch tile.variant {
            case .dirt:
                Color.brown
                    .brightness(-0.1)
                    .overlay(alignment: .topLeading) {
                        // streaks every few points
                        let spacing: CGFloat = 30
                        let startingOffset = size.minX.remainder(dividingBy: spacing)
                        ForEach(0..<Int((size.width - startingOffset)/spacing + 1), id: \.self) { index in
                            Rectangle()
                                .fill(Color.brown)
                                .brightness(-0.12)
                                .frame(width: spacing/2)
                                .offset(x: -startingOffset + CGFloat(index) * spacing)
                        }
                    }
            }
        }
    }
}

#Preview {
    ZStack(alignment: .topLeading) {
        GroundTileView(tile: .init(frame: .init(x: 0, y: 0, width: 100, height: 100), variant: .dirt))
        GroundTileView(tile: .init(frame: .init(x: 100, y: 0, width: 100, height: 100), variant: .dirt))
        GroundTileView(tile: .init(frame: .init(x: 0, y: 100, width: 100, height: 100), variant: .dirt))
        GroundTileView(tile: .init(frame: .init(x: 100, y: 100, width: 100, height: 100), variant: .dirt))
    }
    .frame(width: 200, height: 200, alignment: .topLeading)
}
