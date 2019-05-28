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
        guard (try? DataController.setup()) != nil else {
            return
        }

        if let path = Bundle.main.url(forResource: jsonDataSourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                DataController.loadFeatDataFrom(json: data)
                    .subscribe()
                    .disposed(by: disposeBag)
            } catch {
                print("Error loading feats: \(error)")
            }
        }
        
        if let path = Bundle.main.url(forResource: spellDataSourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                DataController.loadSpellDataFrom(json: data)
                    .subscribe()
                    .disposed(by: disposeBag)
            } catch {
                print("Error loading spells: \(error)")
            }
        }
    }
}
