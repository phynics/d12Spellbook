//
//  DataController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 18.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import RxSwift
import CoreStore
import RxCoreStore

class DataController {

    var updateOnDelegateConnect = false
    var delegate: DataControllerDelegate? {
        didSet {
            delegate?.onDataUpdated(.all)
        }
    }

    var defaults = UserDefaults.standard
    let defaultsFeatKey = "LoadedFeatData"

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
            if self.delegate == nil {
                self.updateOnDelegateConnect = true
            }
            self.delegate?.onDataUpdated(.feat)
        }, failure: { _ in
            self.defaults.set(false, forKey: self.defaultsFeatKey)
        })
    }

    func fetchFeatBy(id: Int) -> FeatDataViewModel? {
        if let model = CoreStore.fetchOne(From<FeatDataModel>().where(\.id == id)) {
            return FeatDataViewModel(withModel: model)
        } else {
            return nil
        }
    }

    func fetchFeats(fromSources sources: [String]?, withTypes types: [String]?) -> [FeatDataViewModel] {
        var filteredFeats = CoreStore.fetchAll(From<FeatDataModel>().orderBy(.ascending(\.name)))
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

    private func _decodeFeatsFrom(jsonData data: Data) throws -> [FeatDataModelPfCommunity] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawDecode = try decoder.decode([String: FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return featList
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
