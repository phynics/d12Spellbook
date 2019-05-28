//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 28.05.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

struct FeatDataViewModel {
    let name: String
    let nameWithTypes: String
    let description: NSAttributedString
    let prerequisites: NSAttributedString
    let shortDescription: String
    let sourceName: String
    let types: String
}

extension FeatDataViewModel {
    static func createFrom(Internal model: FeatDataInternalModel) -> FeatDataViewModel {
        
        let fontAttributesBold: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]
        
        var name = model.featName.value
        
        var type = "\(model.featType.value.capitalizingFirstLetter())"
        if model.featAdditionalTypes.value.count != 0 {
            type += ", \(model.featAdditionalTypes.value)"
        }
        
        var nameWithTypes = "\(name) (\(type))"
        
        var prerequisites = NSMutableAttributedString(string: "Prerequisites: ", attributes: fontAttributesBold)
        prerequisites.append(NSMutableAttributedString(string: model.featPrerequisites.value))
        
        var shortDescription = model.featShortDescription.value
        
        var sourceName = model.featSource.value
        
        let description = NSMutableAttributedString(string: "")
        
        let benefitText = NSMutableAttributedString(string: "Benefit: ", attributes: fontAttributesBold)
        let normalText = NSMutableAttributedString(string: "Normal: ", attributes: fontAttributesBold)
        let specialText = NSMutableAttributedString(string: "Special: ", attributes: fontAttributesBold)
        let goalText = NSMutableAttributedString(string: "Goal: ", attributes: fontAttributesBold)
        let completionText = NSMutableAttributedString(string: "Completion Benefit: ", attributes: fontAttributesBold)
        let noteText = NSMutableAttributedString(string: "Note: ", attributes: fontAttributesBold)
        let sourceText = NSMutableAttributedString(string: "Source: ", attributes: fontAttributesBold)
        let spacing = NSMutableAttributedString(string: "\n\n")
        
        if model.featBenefit.value.count > 0 {
            description.append(benefitText)
            description.append(NSMutableAttributedString(string: model.featBenefit.value))
            description.append(spacing)
        }
        if model.featNormal.value.count > 0 {
            description.append(normalText)
            description.append(NSMutableAttributedString(string: model.featNormal.value))
            description.append(spacing)
        }
        if model.featSpecial.value.count > 0 {
            description.append(specialText)
            description.append(NSMutableAttributedString(string: model.featSpecial.value))
            description.append(spacing)
        }
        if model.featGoal.value.count > 0 {
            description.append(goalText)
            description.append(NSMutableAttributedString(string: model.featGoal.value))
            description.append(spacing)
        }
        if model.featCompletionBenefit.value.count > 0 {
            description.append(completionText)
            description.append(NSMutableAttributedString(string: model.featCompletionBenefit.value))
            description.append(spacing)
        }
        if model.featNote.value.count > 0 {
            description.append(noteText)
            description.append(NSMutableAttributedString(string: model.featNote.value))
            description.append(spacing)
        }
        
        description.append(sourceText)
        description.append(NSMutableAttributedString(string: model.featSource.value))
        
        return FeatDataViewModel(
            name: name,
            nameWithTypes: nameWithTypes,
            description: description,
            prerequisites: prerequisites,
            shortDescription: shortDescription,
            sourceName: sourceName,
            types: type
        )
        
    }
}
