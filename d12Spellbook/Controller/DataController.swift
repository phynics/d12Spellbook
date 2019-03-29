//
//  DataController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 18.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import CoreStore
import RxCoreStore
import RxSwift

class DataController {

    var delegate: DataControllerDelegate?

    var defaults = UserDefaults.standard
    let defaultsFeatKey = "LoadedFeatData"
    let defaultsSpellKey = "LoadedSpellsData"

    init() throws {
        CoreStore.defaultStack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<FeatDataViewModel>("FeatDataViewModel"),
                    Entity<SpellDataViewModel>("SpellDataViewModel")
                ]
            )
        )

        try! CoreStore.addStorageAndWait(
            SQLiteStore(
                fileName: "d12Spellbook.sqlit",
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
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
                let newFeatObject = transaction.create(Into<FeatDataViewModel>())
                newFeatObject.populate(withModel: feat)
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
                let newSpell = transaction.create(Into<SpellDataViewModel>())
                newSpell.populate(withModel: spell)
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
        return try! CoreStore.fetchOne(
            From<FeatDataViewModel>(),
            Where<FeatDataViewModel>("id == %d", id)
        )
    }

    func fetchFeats(fromSources sources: [String]?, withTypes types: [String]?) -> [FeatDataViewModel] {
        var filteredFeats = try? CoreStore.fetchAll(
            From<FeatDataViewModel>(),
            OrderBy<FeatDataViewModel>(.ascending("name"))
        )
        if let sources = sources {
            filteredFeats = filteredFeats?.filter { sources.contains($0.viewSourceName) }
        }
        if let types = types {
            filteredFeats = filteredFeats?.filter { feat in
                if types.contains(feat.featType.value) {
                    return true
                } else {
                    return types.contains { (type) -> Bool in
                        return feat.featAdditionalTypes.value.contains(type)
                    }
                }
            }
        }
        return filteredFeats ?? []
    }

    func fetchSpells() -> [SpellDataViewModel] {
        do {
            let spells = try CoreStore.fetchAll(
                From<SpellDataViewModel>(),
                OrderBy<SpellDataViewModel>(.ascending("name"))
            )
            return spells
        } catch {
            print("Error fetching spells: \(error)")
            return []
        }
    }

    func fetchSpellsUpdating() -> Observable<[SpellDataViewModel]> {
        return CoreStore.rx.monitorList(
            From<SpellDataViewModel>(),
            OrderBy<SpellDataViewModel>(.ascending("name"))
        )
            .filterListDidChange()
            .map { _ in self.fetchSpells() }
            .startWith(fetchSpells())
    }

    private func _decodeFeatsFrom(jsonData data: Data) throws -> [FeatDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        }
        return featList
    }

    private func _decodeSpellsFrom(jsonData data: Data) throws -> [SpellDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: SpellDataModelPfCommunity].self, from: data)
        let spellList = Array(rawDecode.values).sorted { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        }
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
