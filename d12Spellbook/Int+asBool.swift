//
//  Int+asBool.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 2.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

extension Int {
    var asBool: Bool {
        return self != 0 ? true : false
    }
}
