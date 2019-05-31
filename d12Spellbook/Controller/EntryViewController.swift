//
//  EntryViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 26.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EntryViewController: UITabBarController {

    var dataController: DataController?
    
    let disposeBag = DisposeBag()
    
    let jsonDataSourceName = "FeatsPathfinderCommunity221118"
    let spellDataSourceName = "SpellsData22Nov2018"

    override func viewDidLoad() {
        do {
            try DataController.setup()
        } catch {
            print("Failed starting CoreData.")
        }
        var loading = Array<Observable<Void>>()
        if let path = Bundle.main.url(forResource: jsonDataSourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                loading.append(
                    DataController.loadFeatDataFrom(json: data, force: false)
                        )
            } catch {
                print("Error loading feats: \(error)")
            }
        }
        
        if let path = Bundle.main.url(forResource: spellDataSourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                loading.append(
                    DataController.loadSpellDataFrom(json: data, force: false)
                )
            } catch {
                print("Error loading spells: \(error)")
            }
        }
        Observable.concat(loading)
            .subscribe()
            .disposed(by: disposeBag)
    
    }
}
