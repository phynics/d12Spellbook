//
//  SpellListDetailView.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 29.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class SpellListDetailView: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBAction func onDoneButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    var spell: SpellDataViewModel?
    
    override func viewDidLoad() {
        if let spell = spell {
            self.titleLabel.text = spell.viewName
            self.descriptionLabel.attributedText = spell.viewDescription
            self.navTitle.title = "Spell Details"
        }
    }
}
