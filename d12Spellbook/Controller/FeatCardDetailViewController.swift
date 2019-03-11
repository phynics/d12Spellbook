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
        super.viewDidLoad()
        
        if let sourceFeat = self.sourceFeat {
            self.prereqLabel.attributedText = sourceFeat.viewPrerequisites
            self.shortDescLabel.text = sourceFeat.viewShortDescription
            self.descLabel.attributedText = sourceFeat.viewDescription
            self.navigationItem.title = sourceFeat.viewNameWithTypes
        }
    }
}
