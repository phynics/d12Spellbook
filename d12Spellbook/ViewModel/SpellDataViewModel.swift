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

    let componentVerbal = Value.Required<Bool>("componentVerbal", initial: false)
    let componentMaterial = Value.Required<Bool>("componentMaterial", initial: false)
    let componentFocus = Value.Required<Bool>("componentFocus", initial: false)
    let componentDivineFocus = Value.Required<Bool>("componentDivineFocus", initial: false)
    let componentCost = Value.Required<Int>("componentCost", initial: 0)

    var viewName: String {
        return name.value
    }

    var viewSchool: CastingSchool {
        return CastingSchool.init(rawValue: school.value.capitalizingFirstLetter()) ?? CastingSchool.Universal
    }

    var viewSubschools: String {
        return subschool.value
    }

    var viewDescriptors: String {
        return descriptor.value
    }

    var viewComponents: String {
        return components.value
    }

    lazy var viewCastingClasses: [CastingClassSpellLevel] = decodeCastingClasses(json: castingClasses.value)

    var viewSchoolsWithDescriptors: String {
        var schoolWithDesc = school.value.capitalizingFirstLetter()
        if subschool.value.count > 0
            || descriptor.value.count > 0 {
            var comma = false
            if subschool.value.count > 0,
                descriptor.value.count > 0 {
                comma = true
            }
            schoolWithDesc += " ["
            schoolWithDesc += subschool.value
            schoolWithDesc += comma ? ", " : ""
            schoolWithDesc += descriptor.value
            schoolWithDesc += "]"
            return schoolWithDesc
        }
        return schoolWithDesc
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
                    string: viewSchoolsWithDescriptors
                )
            )
            viewDescription.append(spacing)
        }
        if castingClasses.value.count > 0 {
            viewDescription.append(levelText)
            viewDescription.append(NSMutableAttributedString(string: castingClasses.value))
            viewDescription.append(spacing)
        }
        if components.value.count > 0 {
            viewDescription.append(componentsText)
            viewDescription.append(NSMutableAttributedString(string: components.value))
            viewDescription.append(spacing)
        }
        if range.value.count > 0 {
            viewDescription.append(rangeText)
            viewDescription.append(NSMutableAttributedString(string: range.value))
            viewDescription.append(spacing)
        }
        if area.value.count > 0 {
            viewDescription.append(areaText)
            viewDescription.append(NSMutableAttributedString(string: area.value))
            viewDescription.append(spacing)
        }
        if effect.value.count > 0 {
            viewDescription.append(effectText)
            viewDescription.append(NSMutableAttributedString(string: effect.value))
            viewDescription.append(spacing)
        }
        if target.value.count > 0 {
            viewDescription.append(targetText)
            viewDescription.append(NSMutableAttributedString(string: target.value))
            viewDescription.append(spacing)
        }
        if duration.value.count > 0 {
            viewDescription.append(durationText)
            viewDescription.append(NSMutableAttributedString(string: duration.value))
            viewDescription.append(spacing)
        }
        if save.value.count > 0 {
            viewDescription.append(saveText)
            viewDescription.append(NSMutableAttributedString(string: save.value))
            viewDescription.append(spacing)
        }
        if sr.value.count > 0 {
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

        componentVerbal.value = spell.verbal.asBool
        componentFocus.value = spell.focus.asBool
        componentMaterial.value = spell.material.asBool
        componentDivineFocus.value = spell.divineFocus.asBool

        switch spell.materialCosts {
        case let .value(val):
            componentCost.value = val
        case .none:
            componentCost.value = 0
        }

        var casterList: [CastingClassSpellLevel] = []
        casterList.append(CastingClassSpellLevel(castingClass: .sorcerer, spellLevel: spell.sor.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .wizard, spellLevel: spell.wiz.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .cleric, spellLevel: spell.cleric.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .druid, spellLevel: spell.druid.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .ranger, spellLevel: spell.ranger.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .bard, spellLevel: spell.bard.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .paladin, spellLevel: spell.paladin.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .alchemist, spellLevel: spell.alchemist.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .summoner, spellLevel: spell.summoner.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .witch, spellLevel: spell.witch.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .inquisitor, spellLevel: spell.inquisitor.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .oracle, spellLevel: spell.oracle.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .antipaladin, spellLevel: spell.antipaladin.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .magus, spellLevel: spell.magus.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .adept, spellLevel: spell.adept.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .bloodrager, spellLevel: spell.bloodrager.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .shaman, spellLevel: spell.shaman.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .psychic, spellLevel: spell.psychic.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .medium, spellLevel: spell.medium.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .mesmerist, spellLevel: spell.mesmerist.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .occultist, spellLevel: spell.occultist.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .spiritualist, spellLevel: spell.spiritualist.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .skald, spellLevel: spell.skald.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .investigator, spellLevel: spell.investigator.asInt))
        casterList.append(CastingClassSpellLevel(castingClass: .hunter, spellLevel: spell.hunter.asInt))

        do {
            let encoder = JSONEncoder()
            if let casterListJSON = String(data: try encoder.encode(casterList), encoding: .utf8) {
                castingClasses.value = casterListJSON
            }
        } catch {
            print("Encountered error encoding spell level data: \(error.localizedDescription)")
        }

    }

    func decodeCastingClasses(json: String) -> [CastingClassSpellLevel] {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([CastingClassSpellLevel].self, from: json.data(using: .utf8)!)
        } catch {
            print("Encountered error decoding spell level data: \(error.localizedDescription)")
        }
        return []
    }
}

enum CastingClass: String, Codable, CaseIterable {
    case sorcerer = "Sorcerer"
    case wizard = "Wizard"
    case cleric = "Cleric"
    case druid = "Druid"
    case ranger = "Ranger"
    case bard = "Bard"
    case paladin = "Paladin"
    case alchemist = "Alchemist"
    case witch = "Witch"
    case summoner = "Summoner"
    case inquisitor = "Inquisitor"
    case oracle = "Oracle"
    case antipaladin = "Antipaladin"
    case magus = "Magus"
    case adept = "Adept"
    case bloodrager = "Bloodrager"
    case shaman = "Shaman"
    case psychic = "Psychic"
    case medium = "Medium"
    case mesmerist = "Mesmerist"
    case occultist = "Occultist"
    case spiritualist = "Spiritualist"
    case skald = "Skald"
    case investigator = "Investigator"
    case hunter = "Hunter"
    case summonerUnchained = "Unchained Summoner"
}

enum CastingComponent: String, CaseIterable {
    case Verbal = "Verbal"
    case Material = "Material"
    case Costly = "Costly"
    case Focus = "Focus"
    case DivineFocus = "Divine Focus"
}

enum CastingSchool: String, CaseIterable {
    case Abjuration = "Abjuration"
    case Conjuration = "Conjuration"
    case Transmutation = "Transmutation"
    case Illusion = "Illusion"
    case Necromancy = "Necromancy"
    case Enchantment = "Enchantment"
    case Evocation = "Evocation"
    case Divination = "Divination"
    case Universal = "Universal"
}

struct CastingClassSpellLevel: Codable {
    let castingClass: CastingClass
    let spellLevel: Int
}

