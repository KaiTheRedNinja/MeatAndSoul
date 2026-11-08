//
//  Level+Data.swift
//  MeatAndSoul
//
//  Created by Kai Quan Tay on 8/11/26.
//

import SwiftUI

private let levelOne: Level = .init(
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

let allLevels: [Level] = [levelOne]

extension LevelManager {
    static let test: LevelManager = .init(
        level: .init(
            name: "Testing",
            replacements: [
                "A": .init(obstacle: .ichor, movable: .init(linked: "A", frame: .zero, variant: .bridge, orientation: .left, defaultClosed: true, isOpen: false)),
                //                "B": .init(movable: .init(linked: "B", frame: .zero, variant: .bridge, defaultClosed: true, isOpen: false)),
                "C": .init(movable: .init(linked: "C", frame: .zero, variant: .door, orientation: .left, defaultClosed: true, isOpen: false)),
                //                "D": .init(movable: .init(linked: "D", frame: .zero, variant: .door, defaultClosed: true, isOpen: false)),
                "E": .init(interactable: .init(linked: "A", frame: .zero, variant: .button, active: false, orientation: .up)),
                "F": .init(interactable: .init(linked: "C", frame: .zero, variant: .lever, active: false, orientation: .up)),
                "H": .init(obstacle: .ichor, decoration: .init(frame: .init(center: .zero, size: .init(width: 140, height: 70)), variant: .text(.init(text: "Ghosts cannot cross Ichor"))))
            ],
            map: """
            ++++++++++
            +~~H~~~  +
            +~G#F A  +
            +~~~~~~   
            +######  +
            +#Z~E C  +
            +######  +
            ++++++++++
            """
        )
    )
}
