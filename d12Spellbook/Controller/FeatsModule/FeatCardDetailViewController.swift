//
//  FeatCardDetailViewController.swift
//  FeatList
//
//  Created by Atakan Dulker on 26.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

class FeatCardDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var prereqLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var sourceFeat: FeatDataViewModel?
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        if let feat = self.sourceFeat {
            self.prereqLabel.attributedText = feat.viewPrerequisites
            self.shortDescLabel.text = feat.viewShortDescription
            self.descLabel.attributedText = feat.viewDescription
            self.titleLabel.text = feat.viewNameWithTypes
            self.navTitle.title = "Feat Details"
        }
    }
}
