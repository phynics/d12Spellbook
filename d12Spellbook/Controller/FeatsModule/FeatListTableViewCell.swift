//
//  FeatListTableViewCell.swift
//  FeatList
//
//  Created by Atakan Dulker on 25.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

class FeatListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var _sourceFeat: FeatDataViewModel?
    
    var sourceFeat: FeatDataViewModel? {
        get {
            return self._sourceFeat
        }
        set {
            self.titleLabel.text = newValue?.name
            self.descriptionLabel.text = newValue?.types
            self._sourceFeat = newValue
        }
    }
}
