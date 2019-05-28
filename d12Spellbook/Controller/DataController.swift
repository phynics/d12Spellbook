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
                    Entity<FeatDataViewModel>("FeatDataViewModel"),
                    Entity<SpellDataViewModel>("SpellDataViewModel")
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
            let loadedFeats = try FeatDataModelPfCommunity.createFrom(JsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsFeatKey) {
                    return
                }
            }
            for feat in loadedFeats {
                let newFeatObject = transaction.create(Into<FeatDataViewModel>())
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
            let loadedSpells = try SpellDataModelPfCommunity.createFrom(JsonData: json)
            if !force {
                if self.defaults.bool(forKey: self.defaultsSpellKey) {
                    return
                }
            }
            for spell in loadedSpells {
                let newSpell = transaction.create(Into<SpellDataViewModel>())
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

    static func fetchFeatBy(id: Int) -> FeatDataViewModel? {
        return try! CoreStore.fetchOne(
            From<FeatDataViewModel>(),
            Where<FeatDataViewModel>("id == %d", id)
        )
    }

    static func feats(FromSources sourcesList: [String]?, WithTypes typesList: [String]?) -> Observable<[FeatDataViewModel]> {
        return fetchFeats()
            .map { featsList -> [FeatDataViewModel] in
                var filteredList = featsList
                if let sourcesList = sourcesList {
                    filteredList = filteredList.filter({ (feat) -> Bool in
                        sourcesList.contains(feat.viewSourceName)
                    })
                }
                return filteredList
            }
            .map { featsList -> [FeatDataViewModel] in
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

    static func fetchFeats() -> Observable<[FeatDataViewModel]> {
        return Observable.just(
            try! CoreStore.fetchAll(
                From<FeatDataViewModel>(),
                OrderBy<FeatDataViewModel>(.ascending("name"))
            )
        )
    }

    static func fetchFeatsUpdating() -> Observable<[FeatDataViewModel]> {
        return Observable<[FeatDataViewModel]>.concat(
            fetchFeats(),
            CoreStore.rx.monitorList(
                From<FeatDataViewModel>(),
                OrderBy<FeatDataViewModel>(.ascending("name"))
            )
                .filterListDidChange()
                .flatMap { _ in fetchFeats() }
        )
    }

    static func fetchSpells() -> Observable<[SpellDataViewModel]> {
        return Observable<[SpellDataViewModel]>.just (
            try! CoreStore.fetchAll(
                From<SpellDataViewModel>(),
                OrderBy<SpellDataViewModel>(.ascending("name"))
            )
        )
    }

    static func fetchSpellsUpdating() -> Observable<[SpellDataViewModel]> {
        return Observable<[SpellDataViewModel]>.concat(
            fetchSpells(),
            CoreStore.rx.monitorList(
                From<SpellDataViewModel>(),
                OrderBy<SpellDataViewModel>(.ascending("name"))
            )
                .filterListDidChange()
                .flatMap { _ in fetchSpells() }
        )
    }
}
