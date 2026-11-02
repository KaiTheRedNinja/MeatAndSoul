//
//  GameManager.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 2/11/26.
//

import SwiftUI

@Observable
class LevelManager {
    var players: [PlayerVariant: Player] = [:]
    var tiles: TileMap

    init(players: [PlayerVariant : Player], tiles: TileMap) {
        self.players = players
        self.tiles = tiles
    }
}
