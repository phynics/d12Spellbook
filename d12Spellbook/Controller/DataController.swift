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
    static var defaults = UserDefaults.standard
    static let defaultsFeatKey = "LoadedFeatData"
    static let defaultsSpellKey = "LoadedSpellsData"

    static let backgroundQueue = ConcurrentDispatchQueueScheduler(qos: .userInitiated)

    static let spells = BehaviorSubject<[SpellDataViewModel]>(value: [])
    static let feats = BehaviorSubject<[FeatDataViewModel]>(value: [])

    static func setup() throws {
        CoreStore.defaultStack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<FeatDataInternalModel>("FeatDataInternalModel"),
                    Entity<SpellDataInternalModel>("SpellDataInternalModel")
                ]
            )
        )

        try CoreStore.addStorageAndWait(SQLiteStore(
            fileName: "d12Spellbook.sqlite",
            localStorageOptions: .recreateStoreOnModelMismatch
        ))
        

        _fetchSpellsUpdating()
            .share()
            .subscribe(spells.asObserver())
        _fetchFeatsUpdating()
            .share()
            .subscribe(feats.asObserver())


    }

    static func loadFeatDataFrom(json: Data, force: Bool = false) -> Observable<Void> {
        return CoreStore.rx.perform(asynchronous: { (transaction) -> Void in
            let loadedFeats = try FeatDataModelJSON.createFrom(JsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsFeatKey) {
                    print("Skipped JSON import.")
                    return
                }
            }
            
            for feat in loadedFeats {
                let newFeat = transaction.create(Into<FeatDataInternalModel>())
                newFeat.populate(withModel: feat)
            }
        })
            .do(
                onError: { error in
                    self.defaults.set(false, forKey: self.defaultsFeatKey)
            },
                onCompleted: {
                    self.defaults.set(true, forKey: self.defaultsFeatKey)
            }
        )
    }

    static func loadSpellDataFrom(json: Data, force: Bool = false) -> Observable<Void> {
        return CoreStore.rx.perform(asynchronous: { (transaction) -> Void in
            let loadedSpells = try SpellDataModelJSON.createFrom(JsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsSpellKey) {
                    print("Skipped JSON import.")
                    return
                }
            }
            
            for spell in loadedSpells {
                let newSpell = transaction.create(Into<SpellDataInternalModel>())
                newSpell.populate(withModel: spell)
            }
        })
            .do(
                onError: { error in
                    self.defaults.set(false, forKey: self.defaultsSpellKey)
                },
                onCompleted: {
                    self.defaults.set(true, forKey: self.defaultsSpellKey)
                }
            )
    }

    static func feats(FromSources sourcesList: [String]?, WithTypes typesList: [String]?) -> Observable<[FeatDataViewModel]> {
        return feats
            .map { featsList -> [FeatDataViewModel] in
                var filteredList = featsList
                if let sourcesList = sourcesList {
                    filteredList = filteredList.filter({ (feat) -> Bool in
                        sourcesList.contains(feat.sourceName)
                    })
                }
                return filteredList
            }
            .map { featsList -> [FeatDataViewModel] in
                var filteredList = featsList
                if let typesList = typesList {
                    filteredList = filteredList.filter { feat in
                        typesList.contains(where: { type -> Bool in
                            return feat.types.contains(type)
                        })
                    }
                }
                return filteredList
        }
    }

    private static func _fetchFeats() -> Observable<[FeatDataViewModel]> {
        return CoreStore.rx.perform(asynchronous: { (transaction) -> [FeatDataViewModel] in
            return try! transaction.fetchAll(
                From<FeatDataInternalModel>(),
                OrderBy<FeatDataInternalModel>(.ascending("name"))
            )
                .map {
                    FeatDataViewModel.createFrom(Internal: $0)
            }
        })
            .subscribeOn(backgroundQueue)
    }

    private static func _fetchSpells() -> Observable<[SpellDataViewModel]> {
        return CoreStore.rx.perform(asynchronous: { (transaction) -> [SpellDataViewModel] in
            return try! transaction.fetchAll(
                From<SpellDataInternalModel>(),
                OrderBy<SpellDataInternalModel>(.ascending("name"))
            )
                .map {
                    SpellDataViewModel.createFrom(Internal: $0)
            }
        })
            .subscribeOn(backgroundQueue)
    }

    private static func _fetchFeatsUpdating() -> Observable<[FeatDataViewModel]> {
        return Observable<[FeatDataViewModel]>.concat(
            _fetchFeats(),
            CoreStore.rx.monitorList(
                From<FeatDataInternalModel>(),
                OrderBy<FeatDataInternalModel>(.ascending("name"))
            )
                .filterListDidChange()
                .flatMap { _ in _fetchFeats() }
        )
    }

    private static func _fetchSpellsUpdating() -> Observable<[SpellDataViewModel]> {
        return Observable<[SpellDataViewModel]>.concat(
            _fetchSpells(),
            CoreStore.rx.monitorList(
                From<SpellDataInternalModel>(),
                OrderBy<SpellDataInternalModel>(.ascending("name"))
            )
                .do { print("preFilterChange") }
                .filterListDidChange()
                .do { print("postFilterChange") }
                .flatMap { _ in _fetchSpells() }
        )
    }
}
