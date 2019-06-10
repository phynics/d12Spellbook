//
//  AboutTableViewCell.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 10.06.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class AboutTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowImage: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var collapsed = true
    var source: AboutModel? {
        didSet {
            titleLabel.text = source?.title
            descriptionLabel.isHidden = true
        }
    }
    
    func toggleState() {
        if collapsed {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.toValue = CGFloat.pi/2
            animation.duration = 0.3
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            arrowImage.layer.add(animation, forKey: nil)
            
            descriptionLabel.text = source?.description
            descriptionLabel.isHidden = false
            collapsed = false
        } else {
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.toValue = CGFloat.zero
            animation.duration = 0.3
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            arrowImage.layer.add(animation, forKey: nil)
            
            descriptionLabel.text = nil
            descriptionLabel.isHidden = true
            collapsed = true
        }
    }

}
