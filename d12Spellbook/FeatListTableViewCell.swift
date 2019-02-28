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
    
    var title: String {
        get {
            if let text = self.titleLabel?.text {
                return text
            } else {
                return ""
            }
        }
        set {
            if let titleLabel = self.titleLabel {
                titleLabel.text = newValue
            }
        }
    }
    var desc: String {
        get {
            if let text = self.descriptionLabel?.text {
                return text
            } else {
                return ""
            }
        }
        set {
            if let descriptionLabel = self.descriptionLabel {
                descriptionLabel.text = newValue
            }
        }
    }
}
