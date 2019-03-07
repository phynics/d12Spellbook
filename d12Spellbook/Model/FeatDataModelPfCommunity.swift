//
//  FeatDataModelPfCommunity.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

struct FeatDataModelPfCommunity {
    var id: Int
    var name: String
    var type: String
    var additionalTypes: String
    var shortDesc: String
    var prerequisites: String
    var prerequisiteFeats: String
    var prerequisiteSkills: String
    var prerequisiteRace: String
    var benefit: String
    var normal: String
    var special: String
    var note: String
    var goal: String
    var completionBenefit: String
    var multiplesAllowed: Bool
    var sourceName: String
    var fullText: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case shortDesc = "description"
        case prerequisites
        case prerequisiteFeats = "prerequisite_feats"
        case prerequisiteSkills = "prerequisite_skills"
        case prerequisiteRace = "race_name"
        case benefit
        case normal
        case special
        case goal
        case completionBenefit = "completion_benefit"
        case note
        case multiplesAllowed = "multiples"
        case sourceName = "source"
        case fullText = "fulltext"
        
        case teamwork
        case critical
        case grit
        case style
        case performance
        case racial
        case companionOrFamiliar = "companion_familiar"
        case panache
        case betrayal
        case targeting
        case esoteric
        case stare
        case weaponMastery = "weapon_mastery"
        case itemMastery = "item_mastery"
        case armorMastery = "armor_mastery"
        case shieldMastery = "shield_mastery"
        case bloodHex = "blood_hex"
        case trick
    }
}

extension FeatDataModelPfCommunity: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey:.id)
        name = try values.decode(String.self, forKey:.name)
        type = try values.decode(String.self, forKey:.type)
        shortDesc = try values.decode(String.self, forKey:.shortDesc)
        prerequisites = try values.decode(String.self, forKey:.prerequisites)
        prerequisiteFeats = try values.decode(String.self, forKey:.prerequisiteFeats)
        prerequisiteSkills = try values.decode(String.self, forKey:.prerequisiteSkills)
        prerequisiteRace = try values.decode(String.self, forKey: .prerequisiteRace)
        benefit = try values.decode(String.self, forKey:.benefit)
        normal = try values.decode(String.self, forKey:.normal)
        special = try values.decode(String.self, forKey:.special)
        note = try values.decode(String.self, forKey: .note)
        goal = try values.decode(String.self, forKey: .goal)
        completionBenefit = try values.decode(String.self, forKey: .completionBenefit)
        multiplesAllowed = try values.decode(Int.self, forKey: .multiplesAllowed).asBool
        sourceName = try values.decode(String.self, forKey:.sourceName)
        fullText = try values.decode(String.self, forKey:.fullText)
        
        var additionalTypesArray = [String]()
        if try values.decode(Int.self, forKey: .teamwork).asBool {
            additionalTypesArray.append("Teamwork")
        }
        if try values.decode(Int.self, forKey: .critical).asBool {
            additionalTypesArray.append("Critical")
        }
        if try values.decode(Int.self, forKey: .grit).asBool {
            additionalTypesArray.append("Grit")
        }
        if try values.decode(Int.self, forKey: .style).asBool {
            additionalTypesArray.append("Style")
        }
        if try values.decode(Int.self, forKey: .performance).asBool {
            additionalTypesArray.append("Performance")
        }
        if try values.decode(Int.self, forKey: .racial).asBool {
            additionalTypesArray.append("Racial")
        }
        if try values.decode(Int.self, forKey: .companionOrFamiliar).asBool {
            additionalTypesArray.append("Companion/Familiar")
        }
        if try values.decode(Int.self, forKey: .panache).asBool {
            additionalTypesArray.append("Panache")
        }
        if try values.decode(Int.self, forKey: .betrayal).asBool {
            additionalTypesArray.append("Betrayal")
        }
        if try values.decode(Int.self, forKey: .targeting).asBool {
            additionalTypesArray.append("Targeting")
        }
        if try values.decode(Int.self, forKey: .esoteric).asBool {
            additionalTypesArray.append("Esoteric")
        }
        if try values.decode(Int.self, forKey: .stare).asBool {
            additionalTypesArray.append("Stare")
        }
        if try values.decode(Int.self, forKey: .weaponMastery).asBool {
            additionalTypesArray.append("Weapon Mastery")
        }
        if try values.decode(Int.self, forKey: .itemMastery).asBool {
            additionalTypesArray.append("Item Mastery")
        }
        if try values.decode(Int.self, forKey: .armorMastery).asBool {
            additionalTypesArray.append("Armor Mastery")
        }
        if try values.decode(Int.self, forKey: .shieldMastery).asBool {
            additionalTypesArray.append("Shield Mastery")
        }
        if try values.decode(Int.self, forKey: .bloodHex).asBool {
            additionalTypesArray.append("Blood Hex")
        }
        if try values.decode(Int.self, forKey: .trick).asBool {
            additionalTypesArray.append("Trick")
        }
        
        additionalTypesArray.sort()
        additionalTypes = additionalTypesArray.joined(separator: ", ")
    }
}


