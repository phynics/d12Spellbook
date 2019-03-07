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
    
    var sourceFeat: FeatData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sourceFeat = self.sourceFeat {
            let formattedFeat = _setFormatting(forFeat: sourceFeat)
            
            self.prereqLabel.attributedText = formattedFeat.prereq
            self.shortDescLabel.text = formattedFeat.shortDesc
            self.descLabel.attributedText = formattedFeat.desc
            self.navigationItem.title = formattedFeat.name
            
        }
    }
    
    
    private func _setFormatting(forFeat feat: FeatData) -> (name: String, shortDesc: String, desc: NSAttributedString, prereq: NSAttributedString) {
        let fontAttributes: [NSAttributedString.Key : Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]
        let benefitText = NSMutableAttributedString(string: "Benefit: ", attributes: fontAttributes)
        let normalText = NSMutableAttributedString(string: "Normal: ", attributes: fontAttributes)
        let specialText = NSMutableAttributedString(string: "Special: ", attributes: fontAttributes)
        let goalText = NSMutableAttributedString(string: "Goal: ", attributes: fontAttributes)
        let completionText = NSMutableAttributedString(string: "Completion Benefit: ", attributes: fontAttributes)
        let noteText = NSMutableAttributedString(string: "Note: ", attributes: fontAttributes)
        let sourceText = NSMutableAttributedString(string: "Source: ", attributes: fontAttributes)
        let spacing = NSMutableAttributedString(string: "\n\n")
        
        let description = NSMutableAttributedString(string: "")
        if(feat.benefit.count > 0) {
            description.append(benefitText)
            description.append(NSMutableAttributedString(string: feat.benefit))
            description.append(spacing)
        }
        if(feat.normal.count > 0) {
            description.append(normalText)
            description.append(NSMutableAttributedString(string: feat.normal))
            description.append(spacing)
        }
        if(feat.special.count > 0) {
            description.append(specialText)
            description.append(NSMutableAttributedString(string: feat.special))
            description.append(spacing)
        }
        if(feat.goal.count > 0) {
            description.append(goalText)
            description.append(NSMutableAttributedString(string: feat.goal))
            description.append(spacing)
        }
        if(feat.completionBenefit.count > 0) {
            description.append(completionText)
            description.append(NSMutableAttributedString(string: feat.completionBenefit))
            description.append(spacing)
        }
        if(feat.note.count > 0) {
            description.append(noteText)
            description.append(NSMutableAttributedString(string: feat.note))
            description.append(spacing)
        }
        
        description.append(sourceText)
        description.append(NSMutableAttributedString(string: feat.sourceName))
        
        let prerequisitesText = NSMutableAttributedString(string: "Prerequisites: ", attributes: fontAttributes)
        prerequisitesText.append(NSMutableAttributedString(string: feat.prerequisites))
        
        var nameText = "\(feat.name)"
        nameText += "("
        nameText += "\(feat.type)"
        if feat.additionalTypes.count != 0 {
            nameText += ",\(feat.additionalTypes)"
        }
        nameText += ")"
        
        return (name: nameText, shortDesc: feat.shortDesc, desc: description, prereq: prerequisitesText)
    }
}
