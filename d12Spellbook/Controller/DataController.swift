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
    var defaults = UserDefaults.standard
    let defaultsFeatKey = "LoadedFeatData"
    let defaultsSpellKey = "LoadedSpellsData"

    let spells: Observable<[SpellDataViewModel]>
    let feats: Observable<[FeatDataViewModel]>

    var featSources: Observable<[String]> {
        return feats.map { featList in
            featList.map { $0.viewSourceName }
                .unique()
        }
    }

    var featTypes: Observable<[String]> {
        return feats.map { featList in
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

    var spellSchools: Observable<[String]> {
        return spells.map { spellsList in
            return spellsList.map {
                $0.viewSchool
            }
                .reduce(into: [String](), { (result, next) in
                    result.append(next)
                })
                .unique()
        }
    }

    var spellClasses: Observable<[String]> {
        let classNames = CastingClass.allCases .map { (option: CastingClass) in option.rawValue }
        return Observable.just(classNames)
    }

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
                fileName: "d12Spellbook.sqlite",
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )

        spells = DataController._fetchSpellsUpdating()
            .share(replay: 1, scope: .whileConnected)
        feats = DataController._fetchFeatsUpdating()
            .share(replay: 1, scope: .whileConnected)
    }

    func loadFeatDataFrom(json: Data, force: Bool = false) -> Observable<Void> {
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

    func loadSpellDataFrom(json: Data, force: Bool = false) -> Observable<Void> {
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

    func fetchFeatBy(id: Int) -> FeatDataViewModel? {
        return try! CoreStore.fetchOne(
            From<FeatDataViewModel>(),
            Where<FeatDataViewModel>("id == %d", id)
        )
    }

    func feats(FromSources sourcesList: [String]?, WithTypes typesList: [String]?) -> Observable<[FeatDataViewModel]> {
        return self.feats
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

    private static func _fetchFeats() -> [FeatDataViewModel] {
        do {
            return try CoreStore.fetchAll(
                From<FeatDataViewModel>(),
                OrderBy<FeatDataViewModel>(.ascending("name"))
            )
        } catch {
            return []
        }

    }

    private static func _fetchFeatsUpdating() -> Observable<[FeatDataViewModel]> {

        return CoreStore.rx.monitorList(
            From<FeatDataViewModel>(),
            OrderBy<FeatDataViewModel>(.ascending("name"))
        )
            .filterListDidChange()
            .map { _ in _fetchFeats() }
            .startWith(_fetchFeats())
    }

    private static func _fetchSpells() -> [SpellDataViewModel] {
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

    private static func _fetchSpellsUpdating() -> Observable<[SpellDataViewModel]> {
        return CoreStore.rx.monitorList(
            From<SpellDataViewModel>(),
            OrderBy<SpellDataViewModel>(.ascending("name"))
        )
            .filterListDidChange()
            .map { _ in _fetchSpells() }
            .startWith(_fetchSpells())
    }
}
