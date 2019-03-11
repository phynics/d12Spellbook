//
//  FeatDataController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 9.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import CoreData

class FeatDataController {
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
    
    private func _loadFeatsFrom(jsonData data: Data) throws -> [FeatDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String:FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return featList
    }
    
    func loadFeatsFromDataModel(withPredicate predicate: NSPredicate?) -> [FeatDataViewModel] {
        let featFetch = FeatDataModel.featFetchRequest()
        featFetch.predicate = predicate
        featFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        let feats = try! context.fetch(featFetch)
        
        return feats.map { FeatDataViewModel(withModel: $0) }
    }
    
    func addFeatToDataModel(_ feat: FeatDataModelPfCommunity) {
        let featEntity = FeatDataModel(context: self.context)
        featEntity.copyDataFrom(jsonMode: feat)
        
        do {
            try context.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
    
}
