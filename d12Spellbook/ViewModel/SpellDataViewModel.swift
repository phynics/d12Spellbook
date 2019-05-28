//
//  SpellDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 28.05.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

struct SpellDataViewModel {
    let name: String
    let school: CastingSchool
    let subschool: String
    let descriptors: String
    let components: [CastingComponent]
    let castingClasses: [CastingClassSpellLevel]
    let schoolsWithDescriptors: String
    let description: NSAttributedString
}

extension SpellDataViewModel {
    static func createFrom(Internal model: SpellDataInternalModel) -> SpellDataViewModel {
        let name = model.name.value
        let school = CastingSchool.init(rawValue: model.school.value.capitalizingFirstLetter()) ?? CastingSchool.Universal
        let subschools = model.subschool.value
        let descriptors = model.descriptor.value
        
        var components: [CastingComponent] = []
        if model.componentVerbal.value {
            components.append(CastingComponent.Verbal)
        }
        if model.componentMaterial.value {
            components.append(CastingComponent.Material)
        }
        if model.componentFocus.value {
            components.append(CastingComponent.Focus)
        }
        if model.componentDivineFocus.value {
            components.append(CastingComponent.DivineFocus)
        }
        if model.componentCost.value > 0 {
            components.append(CastingComponent.Costly)
        }
        if model.componentSomatic.value {
            components.append(CastingComponent.Somatic)
        }
        
        let castingClasses: [CastingClassSpellLevel] = model.decodeCastingClasses()
        
        var schoolsWithDescriptors = model.school.value.capitalizingFirstLetter()
        if model.subschool.value.count > 0
            || model.descriptor.value.count > 0 {
            var comma = false
            if model.subschool.value.count > 0,
                model.descriptor.value.count > 0 {
                comma = true
            }
            schoolsWithDescriptors += " ["
            schoolsWithDescriptors += model.subschool.value
            schoolsWithDescriptors += comma ? ", " : ""
            schoolsWithDescriptors += model.descriptor.value
            schoolsWithDescriptors += "]"
        }
        
        var description = NSMutableAttributedString(string: "")
        let fontAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]
        let spacing = NSMutableAttributedString(string: "\n")
        
        let schoolText = NSMutableAttributedString(string: "School: ", attributes: fontAttributes)
        let levelText = NSMutableAttributedString(string: "Level: ", attributes: fontAttributes)
        let componentsText = NSMutableAttributedString(string: "Components: ", attributes: fontAttributes)
        let rangeText = NSMutableAttributedString(string: "Range: ", attributes: fontAttributes)
        let areaText = NSMutableAttributedString(string: "Area: ", attributes: fontAttributes)
        let effectText = NSMutableAttributedString(string: "Effect: ", attributes: fontAttributes)
        let targetText = NSMutableAttributedString(string: "Target: ", attributes: fontAttributes)
        let durationText = NSMutableAttributedString(string: "Duration: ", attributes: fontAttributes)
        let saveText = NSMutableAttributedString(string: "Saving Throw: ", attributes: fontAttributes)
        let srText = NSMutableAttributedString(string: "Spell Resistance: ", attributes: fontAttributes)
        let mythicText = NSMutableAttributedString(string: "Mythic: ", attributes: fontAttributes)
        
        
        if model.school.value.count > 0 {
            description.append(schoolText)
            description.append(
                NSMutableAttributedString(
                    string: schoolsWithDescriptors
                )
            )
            description.append(spacing)
        }
        if model.castingClasses.value.count > 0 {
            description.append(levelText)
            description.append(
                NSMutableAttributedString(
                    string: castingClasses.filter { $0.spellLevel >= 0 }
                        .map { "\($0.castingClass.rawValue) \($0.spellLevel)" }
                        .joined(separator: ", ")
                )
            )
            description.append(spacing)
        }
        if model.components.value.count > 0 {
            description.append(componentsText)
            description.append(NSMutableAttributedString(string: model.components.value))
            description.append(spacing)
        }
        if model.range.value.count > 0 {
            description.append(rangeText)
            description.append(NSMutableAttributedString(string: model.range.value))
            description.append(spacing)
        }
        if model.area.value.count > 0 {
            description.append(areaText)
            description.append(NSMutableAttributedString(string: model.area.value))
            description.append(spacing)
        }
        if model.effect.value.count > 0 {
            description.append(effectText)
            description.append(NSMutableAttributedString(string: model.effect.value))
            description.append(spacing)
        }
        if model.target.value.count > 0 {
            description.append(targetText)
            description.append(NSMutableAttributedString(string: model.target.value))
            description.append(spacing)
        }
        if model.duration.value.count > 0 {
            description.append(durationText)
            description.append(NSMutableAttributedString(string: model.duration.value))
            description.append(spacing)
        }
        if model.save.value.count > 0 {
            description.append(saveText)
            description.append(NSMutableAttributedString(string: model.save.value))
            description.append(spacing)
        }
        if model.sr.value.count > 0 {
            description.append(srText)
            description.append(NSMutableAttributedString(string: model.sr.value))
            description.append(spacing)
        }
        
        description.append(spacing)
        description.append(NSMutableAttributedString(string: model.shortDescription.value))
        
        if model.mythic.value {
            description.append(spacing)
            description.append(mythicText)
            description.append(NSMutableAttributedString(string: model.mythicDescription.value))
            description.append(spacing)
        }
        
        return SpellDataViewModel(
            name: name,
            school: school,
            subschool: subschools,
            descriptors: descriptors,
            components: components,
            castingClasses: castingClasses,
            schoolsWithDescriptors: schoolsWithDescriptors,
            description: description
        )
    }
}

