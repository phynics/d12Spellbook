//
//  FeatSourceListTableViewCell.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 11.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class FeatSourceListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var enabled: Bool? = true {
        didSet {
            if let enabled = enabled,
                !enabled {
                self.accessoryType = .none
            } else {
                self.accessoryType = .checkmark
            }
        }
    }
    
    var name: String? {
        get {
            return nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
}
