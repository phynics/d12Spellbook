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
    
    var sourceFeat: (name: String, shortDesc: String, desc: String, prereq: String)?
    
    override func viewDidLoad() {
        self.prereqLabel.text = sourceFeat?.prereq
        self.shortDescLabel.text = sourceFeat?.shortDesc
        self.descLabel.text = sourceFeat?.desc
        self.navigationItem.title = sourceFeat?.name
    }
}
