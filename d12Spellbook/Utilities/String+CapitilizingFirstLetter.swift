//
//  String+CapitilizingFirstLetter.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 14.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
