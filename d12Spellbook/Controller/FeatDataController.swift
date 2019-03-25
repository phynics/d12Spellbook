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

    lazy var featList: [FeatDataModel] = self._fetchFeatsFromDataModel(withPredicate: nil)
    
    lazy var availableFeatSources: [String] = {
        return featList
            .map { $0.sourceName }
            .unique()
    }()
    
    lazy var availableFeatTypes: [String] = {
        return featList
            .map { feat -> [String] in
                var types: [String] = [feat.type.capitalizingFirstLetter()]
                let additionalTypes = feat.additionalTypes
                    .split(separator: ",")
                    .map({ (substr) -> String in
                        if substr.hasPrefix(" ") {
                            return String(substr.dropFirst()).capitalizingFirstLetter()
                        } else {
                            return String(substr).capitalizingFirstLetter()
                        }
                    })
                types.append(contentsOf: additionalTypes)
                return types
            }
            .reduce([String]()
                    , { (acc, next) -> [String] in
                        var result = acc
                        result.append(contentsOf: next)
                        return result
                    })
            .unique()
    }()

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
                    _addFeatToDataModel(loadedFeat)
                }
            }
        } catch {
            print("Failed trying to load data from Json \(error.localizedDescription)")
        }
    }

    func fetchFeatBy(id: Int) -> FeatDataViewModel? {
        return featList.filter { $0.id == id }
            .map { FeatDataViewModel(withModel: $0) }
            .first
    }

    func fetchFeats(fromSources sources: [String]?, withTypes types: [String]?) -> [FeatDataViewModel] {
        var filteredFeats = featList

        if let sources = sources {
            filteredFeats = filteredFeats.filter { sources.contains($0.sourceName) }
        }
        if let types = types {
            filteredFeats = filteredFeats.filter { feat in
                if types.contains(feat.type) {
                    return true
                } else {
                    return types.contains(where: { (type) -> Bool in
                        feat.additionalTypes.contains(type)
                    })
                }
            }
        }
        return filteredFeats.map { FeatDataViewModel(withModel: $0) }
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

    private func _addFeatToDataModel(_ feat: FeatDataModelPfCommunity) {
        let featEntity = FeatDataModel(context: self.context)
        featEntity.copyDataFrom(jsonModel: feat)

        do {
            try context.save()
        } catch {
            print("Could not save. \(error)")
        }
    }
}
