//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit
import CoreStore
import RxCoreStore

class FeatDataViewModel: CoreStoreObject {
    
    let featBenefit = Value.Required<String>("benefit", initial: "")
    let featNormal = Value.Required<String>("normal", initial: "")
    let featSpecial = Value.Required<String>("special", initial: "")
    let featGoal = Value.Required<String>("goal", initial: "")
    let featCompletionBenefit = Value.Required<String>("completionBenefit", initial: "")
    let featNote = Value.Required<String>("note", initial: "")
    let featSource = Value.Required<String>("source", initial: "")
    let featName = Value.Required<String>("name", initial: "")
    let featPrerequisites = Value.Required<String>("prerequisites", initial: "")
    let featShortDescription = Value.Required<String>("shortDesc", initial: "")
    let featType = Value.Required<String>("type", initial: "")
    let featAdditionalTypes = Value.Required<String>("additionalTypes", initial: "")
    
    var viewNameWithTypes: String {
        var nameText = "\(viewName)"
        nameText += " ("
        nameText += "\(viewTypes)"
        nameText += ")"
        
        return nameText
        
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
        if(featBenefit.value.count > 0) {
            viewDescription.append(benefitText)
            viewDescription.append(NSMutableAttributedString(string: featBenefit.value))
            viewDescription.append(spacing)
        }
        if(featNormal.value.count > 0) {
            viewDescription.append(normalText)
            viewDescription.append(NSMutableAttributedString(string: featNormal.value))
            viewDescription.append(spacing)
        }
        if(featSpecial.value.count > 0) {
            viewDescription.append(specialText)
            viewDescription.append(NSMutableAttributedString(string: featSpecial.value))
            viewDescription.append(spacing)
        }
        if(featGoal.value.count > 0) {
            viewDescription.append(goalText)
            viewDescription.append(NSMutableAttributedString(string: featGoal.value))
            viewDescription.append(spacing)
        }
        if(featCompletionBenefit.value.count > 0) {
            viewDescription.append(completionText)
            viewDescription.append(NSMutableAttributedString(string: featCompletionBenefit.value))
            viewDescription.append(spacing)
        }
        if(featNote.value.count > 0) {
            viewDescription.append(noteText)
            viewDescription.append(NSMutableAttributedString(string: featNote.value))
            viewDescription.append(spacing)
        }

        viewDescription.append(sourceText)
        viewDescription.append(NSMutableAttributedString(string: featSource.value))

        return viewDescription
    }
    
    var viewName: String {
        return self.featName.value
    }

    var viewPrerequisites: NSAttributedString {
        let fontAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]

        let prerequisitesText = NSMutableAttributedString(string: "Prerequisites: ", attributes: fontAttributes)
        prerequisitesText.append(NSMutableAttributedString(string: featPrerequisites.value))
        
        return prerequisitesText
    }

    var viewShortDescription: String {
        return featShortDescription.value
    }
    
    var viewSourceName: String {
        return featSource.value
    }
    
    var viewTypes: String {
        var typeText = "\(featType.value.capitalizingFirstLetter())"
        if featAdditionalTypes.value.count != 0 {
            typeText += ", \(featAdditionalTypes.value)"
        }
        return typeText
    }
    
    func populate(withModel feat: FeatDataModelPfCommunity) {
        featBenefit.value = feat.benefit
        featNormal.value = feat.normal
        featSpecial.value = feat.special
        featGoal.value = feat.goal
        featCompletionBenefit.value = feat.completionBenefit
        featNote.value = feat.note
        featSource.value = feat.source
        featName.value = feat.name
        featPrerequisites.value = feat.prerequisites
        featShortDescription.value = feat.description
        featType.value = feat.type
        featAdditionalTypes = feat.additionalTypes
    }
}
