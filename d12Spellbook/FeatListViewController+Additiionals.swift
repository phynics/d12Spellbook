//
//  FeatListViewController+Additiionals.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 2.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit

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
            print(indexPath.row)
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
