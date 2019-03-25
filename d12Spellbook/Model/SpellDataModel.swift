//
//  SpellDataModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 15.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import CoreData

@objc(SpellDataModel)

class SpellDataModel: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var school: String
    @NSManaged var subschools: String
    @NSManaged var descriptors: String
    @NSManaged var spellLevel: String
    @NSManaged var castingTime: String
    @NSManaged var components: String
    @NSManaged var costlyComponents: Bool
    @NSManaged var range: String
    @NSManaged var area: String
    @NSManaged var effect: String
    @NSManaged var targets: String
    @NSManaged var duration: String
    @NSManaged var dismissible: Bool
    @NSManaged var shapeable: Bool
    @NSManaged var savingThrow: String
    @NSManaged var spellResistence: String
    @NSManaged var spellDescription: String
    @NSManaged var sourceBook: String
    @NSManaged var verbal: Bool
    @NSManaged var somatic: Bool
    @NSManaged var material: Bool
    @NSManaged var focus: Bool
    @NSManaged var divineFocus: Bool
    @NSManaged var sorcerer: Int
    @NSManaged var wizard: Int
    @NSManaged var cleric: Int
    @NSManaged var druid: Int
    @NSManaged var ranger: Int
    @NSManaged var bard: Int
    @NSManaged var paladin: Int
    @NSManaged var alchemist: Int
    @NSManaged var summoner: Int
    @NSManaged var witch: Int
    @NSManaged var inquisitor: Int
    @NSManaged var oracle: Int
    @NSManaged var antipaladin: Int
    @NSManaged var magus: Int
    @NSManaged var adept: Int
    @NSManaged var bloodrager: Int
    @NSManaged var shaman: Int
    @NSManaged var psychic: Int
    @NSManaged var medium: Int
    @NSManaged var mesmerist: Int
    @NSManaged var occultist: Int
    @NSManaged var spiritualist: Int
    @NSManaged var skald: Int
    @NSManaged var investigator: Int
    @NSManaged var hunter: Int
    @NSManaged var summonerUnchained: Int
    @NSManaged var slaLevel: Int
    @NSManaged var deity: String
    @NSManaged var domain: String
    @NSManaged var shortDescription: String
    @NSManaged var bloodline: String
    @NSManaged var patron: String
    @NSManaged var mythicText: String
    @NSManaged var augmented: String
    @NSManaged var mythic: Bool
}

extension SpellDataModel {
    @nonobjc class func spellFetchRequest() -> NSFetchRequest<SpellDataModel> {
        return NSFetchRequest<SpellDataModel>(entityName: "SpellDataModel")
    }
}

extension SpellDataModel {
    func copyDataFrom(jsonModel com: SpellDataModelPfCommunity) {
        self.id = com.id
        self.name = com.name
        self.school = com.school
        self.subschools = com.subschool
        self.descriptors = com.descriptor
        self.spellLevel = com.spellLevel
        self.castingTime = com.castingTime
        self.components = com.components
        self.range = com.range
        self.area = com.area
        self.effect = com.effect
        self.targets = com.targets
        self.duration = com.duration
        self.costlyComponents = com.costlyComponents.asBool
        self.dismissible = com.dismissible.asBool
        self.shapeable = com.shapeable.asBool
        self.savingThrow = com.savingThrow
        self.spellDescription = com.spellResistence
        self.spellDescription = com.description
        self.sourceBook = com.source
        self.verbal = com.verbal.asBool
        self.somatic = com.somatic.asBool
        self.material = com.material.asBool
        self.focus = com.focus.asBool
        self.divineFocus = com.divineFocus.asBool
        self.deity = com.deity
        self.domain = com.domain
        self.shortDescription = com.shortDescription
        self.bloodline = com.bloodline
        self.patron = com.patron
        self.mythicText = com.mythicText
        self.mythic = com.mythic.asBool
        self.sorcerer = com.sor.asInt
        self.wizard = com.wiz.asInt
        self.cleric = com.cleric.asInt
        self.druid = com.druid.asInt
        self.ranger = com.ranger.asInt
        self.bard = com.bard.asInt
        self.paladin = com.paladin.asInt
        self.alchemist = com.alchemist.asInt
        self.summoner = com.summoner.asInt
        self.summonerUnchained = com.summonerUnchained.asInt
        self.witch = com.witch.asInt
        self.inquisitor = com.inquisitor.asInt
        self.oracle = com.oracle.asInt
        self.antipaladin = com.antipaladin.asInt
        self.magus = com.magus.asInt
        self.adept = com.adept.asInt
        self.bloodrager = com.bloodrager.asInt
        self.shaman = com.shaman.asInt
        self.psychic = com.psychic.asInt
        self.medium = com.medium.asInt
        self.mesmerist = com.mesmerist.asInt
        self.occultist = com.occultist.asInt
        self.spiritualist = com.spiritualist.asInt
        self.skald = com.skald.asInt
        self.investigator = com.investigator.asInt
        self.hunter = com.hunter.asInt
        self.slaLevel = com.slaLevel 
    }
}
