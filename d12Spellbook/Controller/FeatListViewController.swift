//
//  ViewController.swift
//  FeatList
//
//  Created by Atakan Dulker on 25.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class FeatListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var container: NSPersistentContainer!

    var featDataController: FeatDataController?

    var featList: [String: [FeatDataViewModel]]?
    var featListInitials: [String]?

    typealias FeatSourceUse = (name: String, picked: Bool)
    var featSources: [FeatSourceUse]? {
        didSet {
            reloadFeatData()
        }
    }

    var showFilteredList = false
    var filteredFeatList: [FeatDataViewModel]?

    let jsonDataSourceName = "FeatsPathfinderCommunity221118"

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer

        self.featDataController = try! FeatDataController(withContext: container.viewContext)
        _setupFeatData()

        tableView.delegate = self
        tableView.dataSource = self

        searchBar.delegate = self

        hideKeyboardOnTouch()
    }

    @IBAction func filterButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "filterPopUp", sender: self)
    }

    private func _setupFeatData() {
        if let path = Bundle.main.url(forResource: jsonDataSourceName, withExtension: "json") {
            do {
                
                let data = try Data(contentsOf: path)
                self.featDataController?.loadFeatDataFrom(json: data)

                let featSourcesSorted = self.featDataController?.availableFeatSources
                    .sorted(by:) { a, b -> Bool in
                        if a.contains("PFRPG"), !b.contains("PFRPG") {
                            return true
                        } else if !a.contains("PFRPG"), b.contains("PFRPG") {
                            return false
                        } else if a.hasPrefix("AP"), !b.hasPrefix("AP") {
                            return false
                        } else if !a.hasPrefix("AP"), b.hasPrefix("AP") {
                            return true
                        } else {
                            return a.lexicographicallyPrecedes(b)
                        }
                }

                self.featSources = featSourcesSorted?.map({ (featSourceName) -> FeatSourceUse in
                    return (name: featSourceName, picked: true)
                })

            } catch {
                print(error)
            }
        }
    }

    func reloadFeatData() {
        let pickedSouces = self.featSources!
            .filter({ (source) -> Bool in
                return source.picked
            })
            .map({ (source) -> String in
                return source.name

            })
        let feats = self.featDataController?.fetchFeats(fromSources: pickedSouces)
        self.featList = Dictionary(grouping: feats!, by: { String($0.viewName.first!) })
        self.featListInitials = Array(self.featList!.keys).sorted()
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeatCardDetailViewController {
            if let selected = tableView.indexPathForSelectedRow {
                if self.showFilteredList {
                    if let feat = self.filteredFeatList?[selected.row] {
                        vc.sourceFeat = feat
                    }
                } else {
                    if let sectionLetter = self.featListInitials?[selected.section] {
                        if let feat = self.featList?[sectionLetter]?[selected.row] {
                            vc.sourceFeat = feat
                        }
                    }
                }
            }
        }

        if let vc = segue.destination as? FeatSourcePickerViewController {
            vc.sourceDelegate = self
        }
    }


}

extension FeatListViewController: UITableViewDataSource {
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if self.showFilteredList {
            return nil
        } else {
            return self.featListInitials
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if self.showFilteredList {
            return 1
        } else {
            return self.featListInitials?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showFilteredList {
            return self.filteredFeatList?.count ?? 0
        } else {
            if let sectionLetter = self.featListInitials?[section],
                let feat = self.featList?[sectionLetter] {
                return feat.count
            } else {
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "featListCellPrototype") as! FeatListTableViewCell
        if self.showFilteredList {
            if let feat = self.filteredFeatList?[indexPath.row] {
                cell.sourceFeat = feat
            }
        } else {
            if let sectionLetter = self.featListInitials?[indexPath.section] {
                if let feat = self.featList?[sectionLetter]?[indexPath.row] {
                    cell.sourceFeat = feat
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
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.showFilteredList = false
        self.dismissKeyboard()
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showFilteredList = false
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let featList = self.featList else {
            self.filteredFeatList = []
            self.showFilteredList = false
            self.tableView.reloadData()
            return
        }

        self.filteredFeatList = Array(featList.values).reduce(into: [], { (acc, dataArray) in
            acc.append(contentsOf: dataArray)
        }).filter {
            $0.viewName.localizedCaseInsensitiveContains(searchText)
        }

        if(self.filteredFeatList?.count == 0) {
            self.showFilteredList = false
        } else {
            self.showFilteredList = true
        }
        self.tableView.reloadData()
    }
}

extension FeatListViewController: FeatSourcePickerDelegate {
    func lastSourceState(_ sources: [FeatListViewController.FeatSourceUse]) {
        self.featSources = sources
    }
    
    func retrieveSourceState() -> [FeatListViewController.FeatSourceUse]? {
        return self.featSources
    }
    
}
