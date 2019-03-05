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

extension FeatListViewController: UITableViewDataSource {
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.showFilteredList {
            return nil
        } else {
            return self.featListInitals ?? []
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.showFilteredList {
            return 1
        } else {
            return self.featListInitals?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showFilteredList {
            return self.filteredFeatList?.count ?? 0
        }
        
        if let key = self.featListInitals?[section] {
            return self.featList?
                .filter { $0.name.hasPrefix(key) }
                .count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "featListCellPrototype") as! FeatListTableViewCell
        if self.showFilteredList {
            if let feat = self.filteredFeatList?[indexPath.row] {
                cell.title = feat.name
                cell.desc = feat.shortDescription
            }
        } else {
            if let key = self.featListInitals?[indexPath.section] {
                if let sectionIndex = self.featList?.firstIndex(where:)({ $0.name.hasPrefix(key) }) {
                    if let feat = self.featList?[sectionIndex + indexPath.row] {
                        cell.title = feat.name
                        cell.desc = feat.shortDescription
                    }
                }
            }
        }
        
        return cell
    }
}

extension FeatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFeatDetail", sender: nil)
    }
}

extension FeatListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.showFilteredList = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.showFilteredList = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.showFilteredList = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showFilteredList = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredFeatList = self.featList?.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
        if(self.filteredFeatList?.count == 0){
            self.showFilteredList = false
        } else {
            self.showFilteredList = true
        }
        self.tableView.reloadData()
    }
}
