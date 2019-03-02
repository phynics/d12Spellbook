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
        return self.featListInitals ?? []
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.featListInitals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        if let key = self.featListInitals?[indexPath.section] {
            if let sectionIndex = self.featList?.firstIndex(where:)({ $0.name.hasPrefix(key) }) {
                if let feat = self.featList?[sectionIndex + indexPath.row] {
                    cell.title = feat.name
                    cell.desc = feat.description
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
