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

    static let backgroundQueue = SerialDispatchQueueScheduler(qos: .background)


    static func setup() throws {
        CoreStore.defaultStack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<FeatDataInternalModel>("FeatDataViewModel"),
                    Entity<SpellDataInternalModel>("SpellDataViewModel")
                ]
            )
        )

        try! CoreStore.addStorageAndWait(
            SQLiteStore(
                fileName: "d12Spellbook.sqlite",
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
    }

    static func loadFeatDataFrom(json: Data, force: Bool = false) -> Observable<Void> {
        return CoreStore.rx.perform(asynchronous: { (transaction) -> Void in
            let loadedFeats = try FeatDataModelJSON.createFrom(JsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsFeatKey) {
                    return
                }
            }
            for feat in loadedFeats {
                let newFeatObject = transaction.create(Into<FeatDataInternalModel>())
                newFeatObject.populate(withModel: feat)
            }
        })
            .do(
                onError: { error in
                    print("Error occured while parsing feats: \(error)")
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

    static func fetchFeatBy(id: Int) -> FeatDataInternalModel? {
        return try! CoreStore.fetchOne(
            From<FeatDataInternalModel>(),
            Where<FeatDataInternalModel>("id == %d", id)
        )
    }

    static func feats(FromSources sourcesList: [String]?, WithTypes typesList: [String]?) -> Observable<[FeatDataInternalModel]> {
        return fetchFeats()
            .map { featsList -> [FeatDataInternalModel] in
                var filteredList = featsList
                if let sourcesList = sourcesList {
                    filteredList = filteredList.filter({ (feat) -> Bool in
                        sourcesList.contains(feat.viewSourceName)
                    })
                }
                return filteredList
            }
            .map { featsList -> [FeatDataInternalModel] in
                var filteredList = featsList
                if let typesList = typesList {
                    filteredList = filteredList.filter { feat in
                        typesList.contains(where: { type -> Bool in
                            return feat.viewTypes.contains(type)
                        })
                    }
                }
                return filteredList
        }
    }

    static func featSources() -> Observable<[String]> {
        return fetchFeats()
            .map { featList in
                featList.map { $0.viewSourceName }
                    .unique()
        }
    }

    static func featTypes() -> Observable<[String]> {
        return fetchFeats()
            .map { featList in
                let listOfTypes = featList
                    .map { feat -> [String] in
                        let result = feat.viewTypes
                            .split(separator: ",")
                            .map({ (substr) -> String in
                                if substr.hasPrefix(" ") {
                                    return String(substr.dropFirst()).capitalizingFirstLetter()
                                } else {
                                    return String(substr).capitalizingFirstLetter()
                                }
                            })
                        return result
                    }
                    .reduce(into: [String](), { (result, next) in
                        result.append(contentsOf: next)
                    })
                return listOfTypes.unique()
        }
    }

    static func spellSchools() -> Observable<[String]> {
        return fetchSpells().map { spellsList in
            return spellsList.map {
                $0.viewSchool.rawValue
            }
                .reduce(into: [String](), { (result, next) in
                    result.append(next)
                })
                .unique()
        }
    }

    static func fetchFeats() -> Observable<[FeatDataInternalModel]> {
        return Observable.just(
            try! CoreStore.fetchAll(
                From<FeatDataInternalModel>(),
                OrderBy<FeatDataInternalModel>(.ascending("name"))
            )
        )
    }

    static func fetchFeatsUpdating() -> Observable<[FeatDataInternalModel]> {
        return Observable<[FeatDataInternalModel]>.concat(
            fetchFeats(),
            CoreStore.rx.monitorList(
                From<FeatDataInternalModel>(),
                OrderBy<FeatDataInternalModel>(.ascending("name"))
            )
                .filterListDidChange()
                .flatMap { _ in fetchFeats() }
        )
    }

    static func fetchSpells() -> Observable<[SpellDataInternalModel]> {
        return Observable<[SpellDataInternalModel]>.just (
            try! CoreStore.fetchAll(
                From<SpellDataInternalModel>(),
                OrderBy<SpellDataInternalModel>(.ascending("name"))
            ),
            scheduler: backgroundQueue
        )
    }

    static func fetchSpellsUpdating() -> Observable<[SpellDataInternalModel]> {
        return Observable<[SpellDataInternalModel]>.concat(
            fetchSpells(),
            CoreStore.rx.monitorList(
                From<SpellDataInternalModel>(),
                OrderBy<SpellDataInternalModel>(.ascending("name"))
            )
                .filterListDidChange()
                .flatMap { _ in fetchSpells() }
        )
            .observeOn(backgroundQueue)
    }
}
