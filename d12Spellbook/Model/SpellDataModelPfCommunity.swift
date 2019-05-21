//
//  SpellDataModelPfCommunity.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 15.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
struct SpellDataModelPfCommunity: Codable {
    let name: String
    let school: String
    let subschool: String
    let descriptor: String
    let spellLevel: String
    let castingTime: String
    let components: String
    let costlyComponents: Int
    let range: String
    let area: String
    let effect: String
    let targets: String
    let duration: String
    let dismissible: Int
    let shapeable: Int
    let savingThrow: String
    let spellResistence: String
    let description: String
    let descriptionFormated: String
    let source: String
    let fullText: String
    let verbal: Int
    let somatic: Int
    let material: Int
    let focus: Int
    let divineFocus: Int
    let sor: SpellLevel
    let wiz: SpellLevel
    let cleric: SpellLevel
    let druid: SpellLevel
    let ranger: SpellLevel
    let bard: SpellLevel
    let paladin: SpellLevel
    let alchemist: SpellLevel
    let summoner: SpellLevel
    let witch: SpellLevel
    let inquisitor: SpellLevel
    let oracle: SpellLevel
    let antipaladin: SpellLevel
    let magus: SpellLevel
    let adept: SpellLevel
    let slaLevel: NullOrInt
    let deity: String
    let domain: String
    let shortDescription: String
    let acid: Int
    let air: Int
    let chaotic: Int
    let cold: Int
    let curse: Int
    let darkness: Int
    let death: Int
    let disease: Int
    let earth: Int
    let electricity: Int
    let emotion: Int
    let evil: Int
    let fear: Int
    let fire: Int
    let force: Int
    let good: Int
    let languageDependent: Int
    let lawful: Int
    let light: Int
    let mindAffecting: Int
    let pain: Int
    let poison: Int
    let shadow: Int
    let sonic: Int
    let water: Int
    let linktext: String
    let id: Int
    let materialCosts: NullOrInt
    let bloodline: String
    let patron: String
    let mythicText: String
    let augmented: String
    let mythic: Int
    let bloodrager: SpellLevel
    let shaman: SpellLevel
    let psychic: SpellLevel
    let medium: SpellLevel
    let mesmerist: SpellLevel
    let occultist: SpellLevel
    let spiritualist: SpellLevel
    let skald: SpellLevel
    let investigator: SpellLevel
    let hunter: SpellLevel
    let hauntStatistics: String
    let ruse: Int
    let draconic: Int
    let meditative: Int
    let summonerUnchained: SpellLevel
}

enum SpellLevel: Codable {
    case none
    case level(Int)
    
    var asInt: Int {
        switch  self {
        case .none:
            return -1
        case .level(let x):
            return x
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .level(x)
            return
        }
        if let x = try? container.decode(String.self),
            x == "NULL" {
            self = .none
            return
        }
        throw DecodingError.typeMismatch(SpellLevel.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SpellLevel"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none:
            try container.encode(-1)
        case .level(let x):
            try container.encode(x)
        }
    }
}

enum NullOrInt: Codable {
    case none
    case value(Int)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .value(x)
            return
        }
        if let x = try? container.decode(String.self),
            x == "NULL" {
            self = .none
            return
        }
        throw DecodingError.typeMismatch(NullOrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for NullOr"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none:
            try container.encode(-1)
        case .value(let x):
            try container.encode(x)
        }
    }
    
}

extension SpellDataModelPfCommunity {
    static func createFrom(JsonData data: Data) throws -> [SpellDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: SpellDataModelPfCommunity].self, from: data)
        let spellList = Array(rawDecode.values).sorted { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        }
        return spellList
    }
}
