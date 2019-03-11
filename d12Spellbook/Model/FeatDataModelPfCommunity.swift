//
//  FeatDataModelPfCommunity.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

struct FeatDataModelPfCommunity: Codable {
    var id: Int
    var name: String
    var type: String
    // description is the flavor text of the feat
    var description: String
    var prerequisites: String
    var prerequisiteFeats: String
    var prerequisiteSkills: String
    var raceName: String
    var prerequisiteRace: String {
        get {
            return raceName
        }
    }
    var benefit: String
    var normal: String
    var special: String
    var note: String
    var goal: String
    var completionBenefit: String
    var multiples: Int
    var source: String
    var fulltext: String

    var teamwork: Int
    var grit: Int
    var style: Int
    var performance: Int
    var racial: Int
    var companionFamiliar: Int
    var panache: Int
    var betrayal: Int
    var targeting: Int
    var esoteric: Int
    var weaponMastery: Int
    var itemMastery: Int
    var armorMastery: Int
    var shieldMastery: Int
    var bloodHex: Int
    var trick: Int

    var additionalTypes: String {
        get {
            var adTypes: [String] = []

            if teamwork.asBool {
                adTypes.append("Teamwork")
            }

            if grit.asBool {
                adTypes.append("Grit")
            }

            if style.asBool {
                adTypes.append("Style")
            }

            if performance.asBool {
                adTypes.append("Performance")
            }

            if racial.asBool {
                adTypes.append("racial")
            }

            if companionFamiliar.asBool {
                adTypes.append("Companion/Familiar")
            }

            if panache.asBool {
                adTypes.append("Panache")
            }

            if betrayal.asBool {
                adTypes.append("Betrayal")
            }

            if targeting.asBool {
                adTypes.append("Targeting")
            }

            if esoteric.asBool {
                adTypes.append("esoteric")
            }

            if weaponMastery.asBool {
                adTypes.append("Weapon Mastery")
            }

            if itemMastery.asBool {
                adTypes.append("Item Mastery")
            }

            if armorMastery.asBool {
                adTypes.append("Armor Mastery")
            }

            if shieldMastery.asBool {
                adTypes.append("Shield Mastery")
            }

            if bloodHex.asBool {
                adTypes.append("Blood Hex")
            }

            if trick.asBool {
                adTypes.append("Trick")
            }

            return adTypes.joined(separator: ", ")
        }
    }
}
