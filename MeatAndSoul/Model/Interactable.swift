//
//  Interactable.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 4/11/26.
//

import SwiftUI

struct Interactable: Sprite, Identifiable {
    var id: UUID = .init()

    /// The item that it is linked to
    var linked: String
    /// The frame of the interactable
    var frame: CGRect
    /// What interactable this is
    var variant: InteractableVariant
    /// Whether or not it is currently active.
    ///
    /// For a lever, this may be set to `true` at spawn-time. For a button, this value will
    /// be set to false unless the player is currently holding it down.
    var active: Bool
    /// Whether or not a player is currently touching the switch
    var playerTouching: Bool = false
    /// The direction of this interactable
    var orientation: SpriteOrientation
}

enum InteractableVariant: Equatable {
    case button
    case lever
}
