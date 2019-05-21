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
        dataController = try? DataController()

        if let path = Bundle.main.url(forResource: jsonDataSourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                self.dataController?.loadFeatDataFrom(json: data)
                    .subscribe()
                    .disposed(by: disposeBag)
            } catch {
                print("Error loading feats: \(error)")
            }
        }
        
        if let path = Bundle.main.url(forResource: spellDataSourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                self.dataController?.loadSpellDataFrom(json: data)
                    .subscribe()
                    .disposed(by: disposeBag)
            } catch {
                print("Error loading spells: \(error)")
            }
        }
        
        let featVC = (viewControllers![0] as! UINavigationController)
            .topViewController as! FeatListViewController
        let spellVC = (viewControllers![1] as! UINavigationController)
            .topViewController as! SpellListViewController
        
        featVC.dataController = dataController
        spellVC.dataController = dataController
    }
}
