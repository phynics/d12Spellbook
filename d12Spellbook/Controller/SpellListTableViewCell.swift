//
//  SpellListTableViewCell.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 26.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class SpellListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    var spell: SpellDataViewModel? {
        didSet {
            nameLabel.text = spell?.name
            levelLabel.text = spell?.schoolsWithDescriptors
        }
    }
}
