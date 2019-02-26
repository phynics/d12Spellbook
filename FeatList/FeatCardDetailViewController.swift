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
    
    var sourceFeat: FeatCardCodable?
    
    override func viewDidLoad() {
        self.prereqLabel.text = sourceFeat?.prereqs
        self.shortDescLabel.text = sourceFeat?.shortDescription
        self.descLabel.text = sourceFeat?.description
        self.navigationItem.title = sourceFeat?.title
    }
}
