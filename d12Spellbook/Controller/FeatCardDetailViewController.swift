//
//  FeatCardDetailViewController.swift
//  FeatList
//
//  Created by Atakan Dulker on 26.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

class FeatCardDetailViewController: UIViewController {
    @IBOutlet weak var prereqLabel: UILabel!
    @IBOutlet weak var shortDescLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var sourceFeat: FeatDataViewModel?
    
    override func viewDidLoad() {
        if let feat = self.sourceFeat {
            self.prereqLabel.attributedText = feat.viewPrerequisites
            self.shortDescLabel.text = feat.viewShortDescription
            self.descLabel.attributedText = feat.viewDescription
            self.navigationItem.title = feat.viewNameWithTypes
        }
    }
}
