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

    init(withContext context: NSManagedObjectContext) throws {
        self.context = context
    }

    func loadFeatDataFrom(json: Data, force: Bool = false) {
        do {
            let loadedFeats = try _decodeFromJsonData(jsonData: json)
            
            if !force {
                let checkCount = _fetchFeatsFromDataModel(withPredicate: nil).count
                if checkCount > 42 {
                    return
                }
            }
            
            loadedFeats.forEach { (loadedFeat) in
                if fetchFeatBy(id: loadedFeat.id) == nil {
                    addFeatToDataModel(loadedFeat)
                }
            }
        } catch {
            print("Failed trying to load data from Json \(error.localizedDescription)")
        }
    }

    func fetchAvailableFeatSources() -> [String] {
        return _fetchFeatsFromDataModel(withPredicate: nil)
            .map { $0.sourceName }
            .reduce ([String]()) { acc, item -> [String] in
                var result = acc
                if !acc.contains(where: { $0 == item }) {
                    result.append(item)
                }
                return result
        }
    }

    func fetchFeatBy(id: Int) -> FeatDataViewModel? {
        return _fetchFeatsFromDataModel(withPredicate: NSPredicate(format: "id == %d", id))
            .map { FeatDataViewModel(withModel: $0) }
            .first
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
    
    func fetchFeats(fromSources sources: [String]) -> [FeatDataViewModel] {
        if sources.count == 0 {
            return []
        }
        
        let predicateString =  sources.map { _ in "sourceName = %@" }
                .joined(separator: " OR ")
        let predicate = NSPredicate(format: predicateString, argumentArray: sources)
        
        
        return _fetchFeatsFromDataModel(withPredicate: predicate)
            .map { FeatDataViewModel(withModel: $0) }
    }

    private func _fetchFeatsFromDataModel(withPredicate predicate: NSPredicate?) -> [FeatDataModel] {

        let featFetch = FeatDataModel.featFetchRequest()
        featFetch.predicate = predicate
        featFetch.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        let feats = try! context.fetch(featFetch)

        return feats
    }

    private func _decodeFromJsonData(jsonData data: Data) throws -> [FeatDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return featList
    }
}
