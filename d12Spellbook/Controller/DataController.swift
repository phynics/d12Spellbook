//
//  DataController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 18.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import CoreStore

class DataController {

    var delegate: DataControllerDelegate?

    var defaults = UserDefaults.standard
    let defaultsFeatKey = "LoadedFeatData"
    let defaultsSpellKey = "LoadedSpellsData"

    init() throws {
        try CoreStore.addStorageAndWait()
    }

    func loadFeatDataFrom(json: Data, force: Bool = false) {
        CoreStore.perform(asynchronous: { (transaction) -> Void in
            let loadedFeats = try self._decodeFeatsFrom(jsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsFeatKey) {
                    return
                }
            }
            for feat in loadedFeats {
                let newFeatObject = transaction.create(Into<FeatDataModel>())
                newFeatObject.copyDataFrom(jsonModel: feat)
            }
        }, success: { _ in
            self.defaults.set(true, forKey: self.defaultsFeatKey)
            self.delegate?.onDataUpdated(.feat)
        }, failure: { _ in
            self.defaults.set(false, forKey: self.defaultsFeatKey)
        })
    }
    
    func loadSpellDataFrom(json: Data, force: Bool = false) {
        CoreStore.perform(asynchronous: { (transaction) -> Void in
            let loadedSpells = try self._decodeSpellsFrom(jsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsSpellKey) {
                    return
                }
            }
            for spell in loadedSpells {
                let newSpell = transaction.create(Into<SpellDataModel>())
                newSpell.copyDataFrom(jsonModel: spell)
            }
        }, success: { _ in
            self.defaults.set(true, forKey: self.defaultsSpellKey)
            self.delegate?.onDataUpdated(.spell)
        }, failure: { error in
            print(error)
            self.defaults.set(false, forKey: self.defaultsSpellKey)
        })
    }

    func fetchFeatBy(id: Int) -> FeatDataViewModel? {
        let model = try? CoreStore.fetchOne(From<FeatDataModel>().where(\.id == id))
        if let model = model {
            return FeatDataViewModel(withModel: model!)
        } else {
            return nil
        }
    }

    func fetchFeats(fromSources sources: [String]?, withTypes types: [String]?) -> [FeatDataViewModel] {
        var filteredFeats = try? CoreStore.fetchAll(From<FeatDataModel>().orderBy(.ascending(\.name)))
        if let sources = sources {
            filteredFeats = filteredFeats?.filter { sources.contains($0.sourceName) }
        }
        if let types = types {
            filteredFeats = filteredFeats?.filter { feat in
                if types.contains(feat.type) {
                    return true
                } else {
                    return types.contains(where: { (type) -> Bool in
                        feat.additionalTypes.contains(type)
                    })
                }
            }
        }
        return filteredFeats?.map { FeatDataViewModel(withModel: $0) } ?? []
    }
    
    func fetchSpells() -> [SpellDataViewModel] {
        do {
            let spells = try CoreStore.fetchAll(From<SpellDataModel>().orderBy(.ascending(\.name)))
            return spells.map { SpellDataViewModel(withSpell: $0) }
        } catch {
            print("Error fetching spells: \(error)")
            return []
        }
    }

    private func _decodeFeatsFrom(jsonData data: Data) throws -> [FeatDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return featList
    }
    
    private func _decodeSpellsFrom(jsonData data: Data) throws -> [SpellDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: SpellDataModelPfCommunity].self, from: data)
        let spellList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return spellList
    }
}

protocol DataControllerDelegate {
    func onDataUpdated(_: updateType)
}

enum updateType {
    case all
    case feat
    case spell
}
