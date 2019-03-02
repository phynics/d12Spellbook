//
//  FeatPfCommModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 2.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

class FeatPfCommModel {
    var featList: [FeatPfData]
    
    init(withData data: Data) throws {
        let decoder = JSONDecoder()
        let rawDecode = try decoder.decode([String:FeatPfData].self, from: data)
        self.featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
    }
}

struct FeatPfData {
    var id: Int
    var name: String
    var type: String
    var additionalTypes: [String]
    var description: String
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
        case description
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

extension FeatPfData: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey:.id)
        name = try values.decode(String.self, forKey:.name)
        type = try values.decode(String.self, forKey:.type)
        description = try values.decode(String.self, forKey:.description)
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
        
        additionalTypes = [String]()
        if try values.decode(Int.self, forKey: .teamwork).asBool {
            additionalTypes.append("Teamwork")
        }
        if try values.decode(Int.self, forKey: .critical).asBool {
            additionalTypes.append("Critical")
        }
        if try values.decode(Int.self, forKey: .grit).asBool {
            additionalTypes.append("Grit")
        }
        if try values.decode(Int.self, forKey: .style).asBool {
            additionalTypes.append("Style")
        }
        if try values.decode(Int.self, forKey: .performance).asBool {
            additionalTypes.append("Performance")
        }
        if try values.decode(Int.self, forKey: .racial).asBool {
            additionalTypes.append("Racial")
        }
        if try values.decode(Int.self, forKey: .companionOrFamiliar).asBool {
            additionalTypes.append("Companion/Familiar")
        }
        if try values.decode(Int.self, forKey: .panache).asBool {
            additionalTypes.append("Panache")
        }
        if try values.decode(Int.self, forKey: .betrayal).asBool {
            additionalTypes.append("Betrayal")
        }
        if try values.decode(Int.self, forKey: .targeting).asBool {
            additionalTypes.append("Targeting")
        }
        if try values.decode(Int.self, forKey: .esoteric).asBool {
            additionalTypes.append("Esoteric")
        }
        if try values.decode(Int.self, forKey: .stare).asBool {
            additionalTypes.append("Stare")
        }
        if try values.decode(Int.self, forKey: .weaponMastery).asBool {
            additionalTypes.append("Weapon Mastery")
        }
        if try values.decode(Int.self, forKey: .itemMastery).asBool {
            additionalTypes.append("Item Mastery")
        }
        if try values.decode(Int.self, forKey: .armorMastery).asBool {
            additionalTypes.append("Armor Mastery")
        }
        if try values.decode(Int.self, forKey: .shieldMastery).asBool {
            additionalTypes.append("Shield Mastery")
        }
        if try values.decode(Int.self, forKey: .bloodHex).asBool {
            additionalTypes.append("Blood Hex")
        }
        if try values.decode(Int.self, forKey: .trick).asBool {
            additionalTypes.append("Trick")
        }
    }
}
