//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import CoreData

class FeatDataViewModel {
    let context: NSManagedObjectContext
    
    init(withContext context: NSManagedObjectContext, withJsonData jsonData: Data?) throws {
        self.context = context
        
        if let jsonData = jsonData{
            if loadFeatsFromDataModel(withPredicate: nil).count == 0 {
                let loadedFeats = try self._loadFeatsFrom(jsonData: jsonData)
                loadedFeats.forEach { (loadedFeat) in
                    if loadFeatsFromDataModel(withPredicate: NSPredicate(format: "id == %d", loadedFeat.id)).count == 0 {
                        addFeatToDataModel(loadedFeat)
                    }
                }
            }
        }
    }
    
    private func _loadFeatsFrom(jsonData data: Data) throws -> [FeatData] {
        let decoder = JSONDecoder()
        let rawDecode = try decoder.decode([String:FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return featList.map { rawFeat in
            return FeatData(
                id: rawFeat.id,
                name: rawFeat.name,
                shortDesc: rawFeat.shortDesc,
                benefit: rawFeat.benefit,
                normal: rawFeat.normal,
                special: rawFeat.special,
                goal: rawFeat.goal,
                completionBenefit: rawFeat.completionBenefit,
                note: rawFeat.note,
                prerequisites: rawFeat.prerequisites,
                sourceName: rawFeat.sourceName,
                type: rawFeat.type,
                additionalTypes: rawFeat.additionalTypes,
                multipleAllowed: rawFeat.multiplesAllowed
            )
        }
    }
    
    func loadFeatsFromDataModel(withPredicate predicate: NSPredicate?) -> [FeatData] {
        let featFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FeatEntity")
        
        featFetch.predicate = predicate
        featFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        let feats = try! context.fetch(featFetch)
        
        return feats.map { $0 as! FeatEntity}
            .map({ (item) in
            return FeatData.init(fromCoreDataCounterpart: item)
        })
    }
    
    func addFeatToDataModel(_ feat: FeatData) {
        let entity = NSEntityDescription.entity(forEntityName: "FeatEntity", in: self.context)!
        let featEntity = NSManagedObject(entity: entity, insertInto: self.context)
        
        featEntity.setValuesForKeys(feat.asDictionary)
        
        do {
            try context.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
    
}

struct FeatData {    
    let id: Int
    let name: String
    let shortDesc: String
    let benefit: String
    let normal: String
    let special: String
    let goal: String
    let completionBenefit: String
    let note: String
    let prerequisites: String
    let sourceName: String
    let type: String
    let additionalTypes: String
    let multipleAllowed: Bool

}

extension FeatData {
    var asDictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "shortDesc": shortDesc,
            "benefit": benefit,
            "normal": normal,
            "special": special,
            "goal": goal,
            "completionBenefit": completionBenefit,
            "note": note,
            "prerequisites": prerequisites,
            "sourceName": sourceName,
            "type": type,
            "additionalTypes": additionalTypes,
            "multipleAllowed": multipleAllowed
        ]
    }
    
    init(fromCoreDataCounterpart featEntity: FeatEntity) {
        self.id = Int(featEntity.id)
        self.name = featEntity.name!
        self.shortDesc = featEntity.shortDesc!
        self.benefit = featEntity.benefit!
        self.normal = featEntity.normal!
        self.special = featEntity.special!
        self.goal = featEntity.goal!
        self.completionBenefit = featEntity.completionBenefit!
        self.note = featEntity.note!
        self.prerequisites = featEntity.prerequisites!
        self.sourceName = featEntity.sourceName!
        self.type = featEntity.type!
        self.additionalTypes = featEntity.additionalTypes!
        self.multipleAllowed = featEntity.multipleAllowed
    }
}
