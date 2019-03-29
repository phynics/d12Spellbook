//
//  SpellDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 25.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit
import CoreStore

class SpellDataViewModel: CoreStoreObject {
    
    let name = Value.Required<String>("name", initial: "")
    let school = Value.Required<String>("school", initial: "")
    let subschool = Value.Required<String>("subschool", initial: "")
    let components = Value.Required<String>("components", initial: "")
    let descriptor = Value.Required<String>("descriptor", initial: "")
    let castingClasses = Value.Required<String>("castingClasses", initial: "")
    let costlyComponent = Value.Required<Bool>("costlyComponent", initial: false)
    let range = Value.Required<String>("range", initial: "")
    let area = Value.Required<String>("area", initial: "")
    let effect = Value.Required<String>("effect", initial: "")
    let target = Value.Required<String>("target", initial: "")
    let duration = Value.Required<String>("duration", initial: "")
    let save = Value.Required<String>("save", initial: "")
    let sr = Value.Required<String>("sr", initial: "")
    let mythic = Value.Required<Bool>("mythic", initial: false)
    let mythicDescription = Value.Required<String>("mythicDescription", initial: "")
    let shapeable = Value.Required<Bool>("shapeable", initial: false)
    let dismissable = Value.Required<Bool>("dismissable", initial: false)
    let shortDescription = Value.Required<String>("shortDescription", initial: "")

    var schoolsWithDescriptors: String {
        if subschool.value.count > 0
            || descriptor.value.count > 0 {
            var schoolWithDesc = school.value
            var comma = false
            if subschool.value.count > 0,
                descriptor.value.count > 0 {
                comma = true
            }
            schoolWithDesc += " ["
            schoolWithDesc += comma ? ", " : ""
            schoolWithDesc += "]"
            return schoolWithDesc
        }
        return ""
    }
    var viewDescription: NSAttributedString {
        let fontAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]
        
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
        
        let spacing = NSMutableAttributedString(string: "\n")
        let viewDescription = NSMutableAttributedString()
        
        if school.value.count > 0 {
            viewDescription.append(schoolText)
            viewDescription.append(
                NSMutableAttributedString(
                    string: schoolsWithDescriptors
                )
            )
            viewDescription.append(spacing)
        }
        if castingClasses.value.count > 0  {
            viewDescription.append(levelText)
            viewDescription.append(NSMutableAttributedString(string: castingClasses.value))
            viewDescription.append(spacing)
        }
        if components.value.count > 0  {
            viewDescription.append(componentsText)
            viewDescription.append(NSMutableAttributedString(string: components.value))
            viewDescription.append(spacing)
        }
        if range.value.count > 0  {
            viewDescription.append(rangeText)
            viewDescription.append(NSMutableAttributedString(string: range.value))
            viewDescription.append(spacing)
        }
        if area.value.count > 0  {
            viewDescription.append(areaText)
            viewDescription.append(NSMutableAttributedString(string: area.value))
            viewDescription.append(spacing)
        }
        if effect.value.count > 0  {
            viewDescription.append(effectText)
            viewDescription.append(NSMutableAttributedString(string: effect.value))
            viewDescription.append(spacing)
        }
        if target.value.count > 0  {
            viewDescription.append(targetText)
            viewDescription.append(NSMutableAttributedString(string: target.value))
            viewDescription.append(spacing)
        }
        if duration.value.count > 0  {
            viewDescription.append(durationText)
            viewDescription.append(NSMutableAttributedString(string: duration.value))
            viewDescription.append(spacing)
        }
        if save.value.count > 0  {
            viewDescription.append(saveText)
            viewDescription.append(NSMutableAttributedString(string: save.value))
            viewDescription.append(spacing)
        }
        if sr.value.count > 0  {
            viewDescription.append(srText)
            viewDescription.append(NSMutableAttributedString(string: sr.value))
            viewDescription.append(spacing)
        }
        
        viewDescription.append(spacing)
        viewDescription.append(NSMutableAttributedString(string: shortDescription.value))
        
        if mythic.value {
            viewDescription.append(spacing)
            viewDescription.append(mythicText)
            viewDescription.append(NSMutableAttributedString(string: mythicDescription.value))
            viewDescription.append(spacing)
        }
        
        return viewDescription
    }
    
    func populate(withModel spell: SpellDataModelPfCommunity) {
        name.value = spell.name
        school.value = spell.school
        subschool.value = spell.subschool
        descriptor.value = spell.descriptor
        shortDescription.value = spell.description
        castingClasses.value = spell.spellLevel
        components.value = spell.components
        costlyComponent.value = spell.costlyComponents.asBool
        range.value = spell.range
        area.value = spell.area
        effect.value = spell.effect
        target.value = spell.targets
        duration.value = spell.duration
        dismissable.value = spell.dismissible.asBool
        shapeable.value = spell.shapeable.asBool
        save.value = spell.savingThrow
        sr.value = spell.spellResistence
        mythic.value = spell.mythic.asBool
        mythicDescription.value = spell.mythicText
    }
}
