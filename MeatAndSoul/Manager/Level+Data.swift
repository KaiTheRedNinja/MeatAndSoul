//
//  Level+Data.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 8/11/26.
//

import SwiftUI

private let level0: Level = .init(
    name: "Meat+Soul = Human",
    replacements: [
        "a": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Control Meat with Arrow Keys", backgroundColor: Color(white: 0.25, opacity: 0.5))))),
        "b": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Control Soul with WASD", backgroundColor: Color(white: 0.25, opacity: 0.5))))),
        "c": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "They must meet and recombine before exiting", backgroundColor: Color(white: 0.25, opacity: 0.5)))))
    ],
    map: """
    ++++++++
    +Z a   +
    +++++ c.
    +G b   +
    ++++++++
    """
)

private let level1: Level = .init(
    name: "Walls",
    replacements: [
        "a": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Soul can faze through walls, but can't cross ichor", backgroundColor: Color(white: 0.25, opacity: 0.5))))),
        "b": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Meat can swim through ichor, but can't climb over walls", backgroundColor: Color(white: 0.25, opacity: 0.5))))),
        "c": .init(obstacle: .lava, decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Neither can cross lava", backgroundColor: Color(white: 0.25, opacity: 0.5)))))
    ],
    map: """
    ++++++++++
    +~~~~~~  +
    +~G # a  +
    +~~~~~~   
    +######  +
    +#Z ~ b  +
    +######  +
    ++++c+++++
    """
)

let level2_bridge_1 = LinkID(id: "BRIDGE_1", color: .red)
let level2_door_2 = LinkID(id: "DOOR_2", color: .yellow)
let level2_bridge_3 = LinkID(id: "BRIDGE_3", color: .blue)
private let level2: Level = .init(
    name: "Bridges",
    replacements: [
        "a": .init(interactable: .init(linked: level2_bridge_1, frame: .zero, variant: .button, active: false, orientation: .up)),
        "b": .init(obstacle: .lava, movable: .init(linked: level2_bridge_1, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),
        "c": .init(interactable: .init(linked: level2_door_2, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "d": .init(movable: .init(linked: level2_door_2, frame: .zero, variant: .door, orientation: .left, defaultClosed: true, isOpen: false)),
        "e": .init(interactable: .init(linked: level2_bridge_3, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "f": .init(obstacle: .lava, movable: .init(linked: level2_bridge_3, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),

        "x": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Buttons open doors/bridges while you stand on them", backgroundColor: Color(white: 0.25, opacity: 0.5))))),
        "y": .init(decoration: .init(frame: .init(origin: .zero, size: .init(width: 140, height: 70)), variant:
                .text(.init(text: "Levers flip each time you step on/off them", backgroundColor: Color(white: 0.25, opacity: 0.5)))))
    ],
    map: """
    ++++++++++++
    +    x     +
    + +++++##  +
    + +G ade#  +
    + +++++## ++
    +    y   zf.
    +   +++   ++
    + Z bc+    +
    +   +++    +
    +          +
    ++++++++++++
    """
)

let allLevels: [Level] = [level0, level1, level2]
