//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

class FeatDataViewModel {
    private let _sourceFeat: FeatDataModel
    
    init(withModel feat: FeatDataModel) {
        self._sourceFeat = feat
    }
    
    var viewDescription: NSAttributedString {
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
        if(self._sourceFeat.benefit.count > 0) {
            viewDescription.append(benefitText)
            viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.benefit))
            viewDescription.append(spacing)
        }
        if(self._sourceFeat.normal.count > 0) {
            viewDescription.append(normalText)
            viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.normal))
            viewDescription.append(spacing)
        }
        if(self._sourceFeat.special.count > 0) {
            viewDescription.append(specialText)
            viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.special))
            viewDescription.append(spacing)
        }
        if(self._sourceFeat.goal.count > 0) {
            viewDescription.append(goalText)
            viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.goal))
            viewDescription.append(spacing)
        }
        if(self._sourceFeat.completionBenefit.count > 0) {
            viewDescription.append(completionText)
            viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.completionBenefit))
            viewDescription.append(spacing)
        }
        if(self._sourceFeat.note.count > 0) {
            viewDescription.append(noteText)
            viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.note))
            viewDescription.append(spacing)
        }

        viewDescription.append(sourceText)
        viewDescription.append(NSMutableAttributedString(string: self._sourceFeat.sourceName))

        return viewDescription
    }
    
    var viewName: String {
        return self._sourceFeat.name
    }

    var viewNameWithTypes: String {
        var nameText = "\(self.viewName)"
        nameText += " ("
        nameText += "\(self._sourceFeat.type)"
        if self._sourceFeat.additionalTypes.count != 0 {
            nameText += ", \(self._sourceFeat.additionalTypes)"
        }
        nameText += ")"

        return nameText
    }

    var viewPrerequisites: NSAttributedString {
        let fontAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]

        let prerequisitesText = NSMutableAttributedString(string: "Prerequisites: ", attributes: fontAttributes)
        prerequisitesText.append(NSMutableAttributedString(string: self._sourceFeat.prerequisites))
        
        return prerequisitesText
    }

    var viewShortDescription: String {
        return self._sourceFeat.shortDesc
    }
    
    var viewSourceName: String {
        return self._sourceFeat.sourceName
    }
}
