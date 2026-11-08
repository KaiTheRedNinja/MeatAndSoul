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

private let level2: Level = .init(
    name: "Bridges",
    replacements: [
        "a": .init(interactable: .init(linked: .red, frame: .zero, variant: .button, active: false, orientation: .up)),
        "b": .init(obstacle: .lava, movable: .init(linked: .red, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),
        "c": .init(interactable: .init(linked: .yellow, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "d": .init(obstacle: .lava, movable: .init(linked: .yellow, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),
        "e": .init(interactable: .init(linked: .green, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "f": .init(obstacle: .lava, movable: .init(linked: .green, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),

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

private let level3: Level = .init(
    name: "Squeeze",
    replacements: [
        // to enter main hallway
        "a": .init(interactable: .init(linked: .red, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "b": .init(interactable: .init(linked: .yellow, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "c": .init(movable: .init(linked: .red, frame: .zero, variant: .door, orientation: .left, defaultClosed: true, isOpen: false)),
        "d": .init(obstacle: .lava, movable: .init(linked: .yellow, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),

        // to allow zombie to enter middle-bottom chamber
        "e": .init(interactable: .init(linked: .green, frame: .zero, variant: .button, active: false, orientation: .up)),
        "f": .init(obstacle: .ichor, movable: .init(linked: .green, frame: .zero, variant: .door, orientation: .up, defaultClosed: true, isOpen: false)),

        // to allow ghost to enter top-right chamber
        "g": .init(interactable: .init(linked: .pink, frame: .zero, variant: .button, active: false, orientation: .up)),
        "h": .init(obstacle: .lava, movable: .init(linked: .pink, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),

        // to allow zombie to enter bottom-right chamber
        "i": .init(interactable: .init(linked: .cyan, frame: .zero, variant: .button, active: false, orientation: .up)),
        "j": .init(obstacle: .lava, movable: .init(linked: .cyan, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),

        // to open main gate
        "k": .init(interactable: .init(linked: .blue, frame: .zero, variant: .lever, active: false, orientation: .up)),
        "l": .init(obstacle: .lava, movable: .init(linked: .blue, frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),

        "x": .init(obstacle: .lava, decoration: .init(frame: .init(origin: .zero, size: .init(width: 260, height: 80)), variant:
                .text(.init(text: "Human is blocked by ichor, walls, and lava - restart the level if you merged in a bad spot")))),
    ],
    map: """
    ++++x++++++
    +a+   h   +
    +~+ e + i +
    + +   +   +
    +G++#++++++
    + cd     l.
    +Z++f++++++
    + +   +   +
    +#+ g + k +
    +b+   j   +
    +++++++++++
    """
)

let allLevels: [Level] = [level0, level1, level2, level3]
