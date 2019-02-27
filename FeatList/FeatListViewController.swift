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
    
    var featListInitals: [String]?
    var featList: [FeatCardCodable]?

    override func viewDidLoad() {
        super.viewDidLoad()
        _loadFeatList()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func _loadFeatList() {
        let resourceName = "FeatPFRPG-CORE"
        if let path = Bundle.main.url(forResource: resourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                let feats = try FeatCardList(withData: data).featList
                var initials: Array<String> = []
                for feat in feats {
                    let initialLetter = String(feat.title.first!)
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
                if let key = self.featListInitals?[selected.section] {
                    if let sectionIndex = self.featList?.firstIndex(where:)({ $0.title.hasPrefix(key) }) {
                        if let feat = self.featList?[sectionIndex + selected.row] {
                            vc.sourceFeat = feat
                        }
                    }
                }
            }
        }
    }

}

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
                .filter { $0.title.hasPrefix(key) }
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
            if let sectionIndex = self.featList?.firstIndex(where:)({ $0.title.hasPrefix(key) }) {
                if let feat = self.featList?[sectionIndex + indexPath.row] {
                    cell.title = feat.title
                    cell.desc = feat.shortDescription
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
