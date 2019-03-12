//
//  Sequence+Unique.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 12.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element:Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
