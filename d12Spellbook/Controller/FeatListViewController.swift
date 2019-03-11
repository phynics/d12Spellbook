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

    typealias FeatSourceStatus = (name: String, picked: Bool)
    var featSources: [FeatSourceStatus]?

    var showFilteredList = false
    var filteredFeatList: [FeatDataViewModel]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer

        _loadFeatList()
        hideKeyboardOnTouch()

        tableView.delegate = self
        tableView.dataSource = self

        searchBar.delegate = self
    }

    @IBAction func filterButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "filterPopUp", sender: self)
    }

    private func _loadFeatList() {
        let resourceName = "FeatsPathfinderCommunity221118"
        if let path = Bundle.main.url(forResource: resourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                self.featDataController = try FeatDataController(withContext: container.viewContext, withJsonData: data)
                let feats = self.featDataController?.fetchFeatsFromDataModel(withPredicate: nil)

                self.featList = Dictionary(grouping: feats!, by: { String($0.viewName.first!) })

                self.featListInitials = Array(self.featList!.keys).sorted()
                
                self.featSources = self.featDataController?
                    .fetchSources()
                    .map { (name: $0, picked: true) }

            } catch {
                print(error)
            }
        }
    }
    
    func loadFeatList(bySource sources: [FeatSourceStatus]) {
        
        if sources.count == 0 {
            return
        }
        
        var predicateString = "sourceName = %@"
        let pickedSources = sources.filter { $0.picked }
            .map { $0.name }
        
        for _ in 1..<pickedSources.count {
            predicateString += "OR sourceName = %@"
        }
        
        let predicate = NSPredicate(format: predicateString, argumentArray: pickedSources)
        
        
        let feats = self.featDataController!
            .fetchFeatsFromDataModel(withPredicate: predicate)
        self.featList = Dictionary(grouping: feats, by: { String($0.viewName.first!) })
        
        
        self.tableView.reloadData()
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
        return 64.0
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.showFilteredList = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.showFilteredList = false
        tableView.reloadData()
    }

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
    func numberOfSources() -> Int {
        return self.featSources?.count ?? 0
    }
    
    func sourceAtIndex(index: Int) -> (name: String, picked: Bool) {
        return self.featSources![index]
    }
    
    func changed(atIndex index: Int) {
        if var featSources = self.featSources {
            featSources[index].picked = !featSources[index].picked
            self.featSources = featSources
            
            self.loadFeatList(bySource: featSources)
        }
    }
}
