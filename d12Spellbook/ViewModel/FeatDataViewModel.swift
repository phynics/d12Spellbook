//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

class FeatDataViewModel {
    private(set) var viewDescription: NSAttributedString = NSAttributedString()
    private(set) var viewName: String = ""
    private(set) var viewPrerequisites: NSAttributedString = NSAttributedString()
    private(set) var viewSourceName: String = ""
    private(set) var viewShortDescription: String = ""
    private(set) var viewTypes: String = ""
    
    var viewNameWithTypes: String {
        var nameText = "\(viewName)"
        nameText += " ("
        nameText += "\(viewTypes)"
        nameText += ")"
        
        return nameText
        
    }
    
    init(withModel feat: FeatDataModel) {
        self.viewDescription = generateViewDescription(feat: feat)
        self.viewName = generateViewName(feat: feat)
        self.viewPrerequisites = generateViewPrerequisites(feat: feat)
        self.viewSourceName = generateViewSourceName(feat: feat)
        self.viewShortDescription = generateViewShortDescription(feat: feat)
        self.viewTypes = generateViewTypes(feat: feat)
    }
    
    
    func generateViewDescription(feat: FeatDataModel) -> NSAttributedString {
        let fontAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]

        let benefitText = NSMutableAttributedString(string: "Benefit: ", attributes: fontAttributes)
        let normalText = NSMutableAttributedString(string: "Normal: ", attributes: fontAttributes)
        let specialText = NSMutableAttributedString(string: "Special: ", attributes: fontAttributes)
        let goalText = NSMutableAttributedString(string: "Goal: ", attributes: fontAttributes)
        let completionText = NSMutableAttributedString(string: "Completion Benefit: ", attributes: fontAttributes)
        let noteText = NSMutableAttributedString(string: "Note: ", attributes: fontAttributes)
        let sourceText = NSMutableAttributedString(string: "Source: ", attributes: fontAttributes)
        let spacing = NSMutableAttributedString(string: "\n\n")

        let viewDescription = NSMutableAttributedString(string: "")
        if(feat.benefit.count > 0) {
            viewDescription.append(benefitText)
            viewDescription.append(NSMutableAttributedString(string: feat.benefit))
            viewDescription.append(spacing)
        }
        if(feat.normal.count > 0) {
            viewDescription.append(normalText)
            viewDescription.append(NSMutableAttributedString(string: feat.normal))
            viewDescription.append(spacing)
        }
        if(feat.special.count > 0) {
            viewDescription.append(specialText)
            viewDescription.append(NSMutableAttributedString(string: feat.special))
            viewDescription.append(spacing)
        }
        if(feat.goal.count > 0) {
            viewDescription.append(goalText)
            viewDescription.append(NSMutableAttributedString(string: feat.goal))
            viewDescription.append(spacing)
        }
        if(feat.completionBenefit.count > 0) {
            viewDescription.append(completionText)
            viewDescription.append(NSMutableAttributedString(string: feat.completionBenefit))
            viewDescription.append(spacing)
        }
        if(feat.note.count > 0) {
            viewDescription.append(noteText)
            viewDescription.append(NSMutableAttributedString(string: feat.note))
            viewDescription.append(spacing)
        }

        viewDescription.append(sourceText)
        viewDescription.append(NSMutableAttributedString(string: feat.sourceName))

        return viewDescription
    }
    
    func generateViewName(feat: FeatDataModel) -> String {
        return feat.name
    }

    func generateViewPrerequisites(feat: FeatDataModel) -> NSAttributedString {
        let fontAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]

        let prerequisitesText = NSMutableAttributedString(string: "Prerequisites: ", attributes: fontAttributes)
        prerequisitesText.append(NSMutableAttributedString(string: feat.prerequisites))
        
        return prerequisitesText
    }

    func generateViewShortDescription(feat: FeatDataModel) -> String {
        return feat.shortDesc
    }
    
    func generateViewSourceName(feat: FeatDataModel) -> String {
        return feat.sourceName
    }
    
    func generateViewTypes(feat: FeatDataModel) -> String {
        var typeText = "\(feat.type)"
        if feat.additionalTypes.count != 0 {
            typeText += ", \(feat.additionalTypes)"
        }
        return typeText
    }
}
