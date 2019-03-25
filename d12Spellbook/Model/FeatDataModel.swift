//
//  FeatDataModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 11.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import CoreData

@objc(FeatDataModel)

class FeatDataModel: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var shortDesc: String
    @NSManaged var benefit: String
    @NSManaged var normal: String
    @NSManaged var special: String
    @NSManaged var goal: String
    @NSManaged var completionBenefit: String
    @NSManaged var note: String
    @NSManaged var prerequisites: String
    @NSManaged var sourceName: String
    @NSManaged var type: String
    @NSManaged var additionalTypes: String
    @NSManaged var multipleAllowed: Bool
}

extension FeatDataModel {
    @nonobjc class func featFetchRequest() -> NSFetchRequest<FeatDataModel> {
        return NSFetchRequest<FeatDataModel>(entityName: "FeatDataModel")
    }
}

extension FeatDataModel {
    func copyDataFrom(jsonModel com: FeatDataModelPfCommunity) {
        self.id = com.id
        self.name = com.name
        self.shortDesc = com.description
        self.benefit = com.benefit
        self.normal = com.normal
        self.special = com.special
        self.goal = com.goal
        self.completionBenefit = com.completionBenefit
        self.note = com.note
        self.prerequisites = com.prerequisites
        self.sourceName = com.source
        self.type = com.type
        self.additionalTypes = com.additionalTypes
        self.multipleAllowed = com.multiples.asBool
    }
}
