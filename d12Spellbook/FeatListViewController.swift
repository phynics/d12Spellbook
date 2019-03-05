//
//  ViewController.swift
//  FeatList
//
//  Created by Atakan Dulker on 25.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit
import Foundation

class FeatListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var featListInitals: [String]?
    var featList: [FeatDataViewModel]?
    
    var showFilteredList = false
    var filteredFeatList: [FeatDataViewModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        _loadFeatList()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    private func _loadFeatList() {
        let resourceName = "FeatsPathfinderCommunity221118"
        if let path = Bundle.main.url(forResource: resourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let feats = try FeatDataViewModel.fromData(data)
                var initials: Array<String> = []
                for feat in feats {
                    let initialLetter = String(feat.name.first!)
                    if !initials.contains(initialLetter) {
                        initials.append(initialLetter)
                    }
                }
                self.featListInitals = initials
                self.featList = feats
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeatCardDetailViewController {
            if let selected = tableView.indexPathForSelectedRow {
                if self.showFilteredList {
                    if let feat = self.filteredFeatList?[selected.row] {
                        vc.sourceFeat = (feat.name, feat.shortDescription, feat.description, feat.prerequisites)
                    }
                } else {
                    if let key = self.featListInitals?[selected.section] {
                        if let sectionIndex = self.featList?.firstIndex(where:)({ $0.name.hasPrefix(key) }) {
                            if let feat = self.featList?[sectionIndex + selected.row] {
                                vc.sourceFeat = (feat.name, feat.shortDescription, feat.description, feat.prerequisites)
                            }
                        }
                    }
                }
            }
        }
    }

}
