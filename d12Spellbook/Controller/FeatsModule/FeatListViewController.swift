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
import RxSwift
import RxDataSources

class FeatListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .userInitiated)
    let disposeBag = DisposeBag()

    var featSources = BehaviorSubject<[String]>(value: [])
    var featTypes = BehaviorSubject<[String]>(value: [])
    
    // store picked options for filtering
    var featSourcesFilter = BehaviorSubject<[String]>(value: [])
    var featTypeFilter = BehaviorSubject<[String]>(value: [])

    @IBAction func filterButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "filterPopUp", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardOnTouch()


        let tableDataSource = RxTableViewSectionedReloadDataSource<SectionOfFeatDataViewModel>(
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "featCell")
                if let cell = cell as? FeatListTableViewCell {
                    cell.sourceFeat = item
                }
                return cell!
            })

        tableDataSource.sectionIndexTitles = { arg in
            arg.sectionModels.map { $0.header }
        }

        let searchBarFilter = self.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(0.5, scheduler: backgroundScheduler)


        let sourceFilter = featSourcesFilter.observeOn(backgroundScheduler)
        let typeFilter = featTypeFilter.observeOn(backgroundScheduler)
        let feats = DataController.feats.observeOn(backgroundScheduler)

        // Prepare output as the results from feats and various filtering options come.
        Observable.combineLatest(feats, searchBarFilter, sourceFilter, typeFilter)
            .map { (featsResult, searchBarResult, sourceResult, typeResult) -> [FeatDataViewModel] in
                let filteredResult = featsResult
                    .filter { feat in
                        if typeResult.count > 0 {
                            return typeResult.contains { type -> Bool in
                                feat.types.contains(type)
                            }
                        } else {
                            return true
                        }
                    }
                    .filter { feat -> Bool in
                        if sourceResult.count > 0 {
                            return sourceResult.contains(feat.sourceName)
                        } else {
                            return true
                        }
                    }
                    .filter { feat -> Bool in
                        if searchBarResult.count > 0 {
                            return feat.name.contains(searchBarResult)
                        } else {
                            return true
                        }
                    }
                return filteredResult
            }
            .map { featModels in
                return Dictionary.init(grouping: featModels, by: { $0.name.first! })
                    .map { (arg) -> SectionOfFeatDataViewModel in
                        let (key, value) = arg
                        return SectionOfFeatDataViewModel(header: String(key), items: value)
                    }
                    .sorted(by: { (a, b) -> Bool in
                        return a.header.lexicographicallyPrecedes(b.header)
                    })
            }
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: tableDataSource))
            .disposed(by: disposeBag)

        // Setup local feat sources
        DataController.feats
            .map { featList in
                featList.map { $0.sourceName }
                    .unique()
            }
            .map {
                $0.sorted(by:) { a, b -> Bool in
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
            }
            .subscribe(self.featSources)
            .disposed(by: disposeBag)

        // Setup local feat types
        DataController.feats.map {
            $0.map { feat -> [String] in
                let additionalTypes = feat.types
                    .split(separator: ",")
                    .map({ (substr) -> String in
                        if substr.hasPrefix(" ") {
                            return String(substr.dropFirst()).capitalizingFirstLetter()
                        } else {
                            return String(substr).capitalizingFirstLetter()
                        }
                    })
                return additionalTypes
            }
        }
            .map {
                $0.reduce([String](), { (acc, next) -> [String] in
                    var result = acc
                    result.append(contentsOf: next)
                    return result
                })
                    .unique()
            }
            .subscribe(self.featTypes.asObserver())
            .disposed(by: disposeBag)
        
        // Engage segue when an item is selected from the table
        self.tableView.rx.itemSelected.subscribe { [weak self] event in
            self?.performSegue(withIdentifier: "showFeatDetail", sender: nil)
        }
            .disposed(by: disposeBag)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeatListDetailView {
            if let selected = tableView.indexPathForSelectedRow {
                if let featCell = self.tableView.cellForRow(at: selected) as? FeatListTableViewCell? {
                    vc.sourceFeat = featCell?.sourceFeat
                }
            }
        }

        if let vc = segue.destination as? FeatSourcePickerViewController {
            vc.sourceDelegate = self
        }
    }
}

extension FeatListViewController: FeatSourcePickerDelegate {
    func onSourcePicked(_ elem: [String]) {
        self.featSourcesFilter.onNext(elem)
    }

    func onTypePicked(_ elem: [String]) {
        self.featTypeFilter.onNext(elem)
    }

    func pickedSources() -> [String] {
        return (try? self.featSourcesFilter.value()) ?? []
    }

    func pickedTypes() -> [String] {
        return (try? self.featTypeFilter.value()) ?? []
    }

    func availableSources() -> [String] {
        return (try? featSources.value()) ?? []
    }

    func availableTypes() -> [String] {
        return (try? featTypes.value()) ?? []
    }

}

struct SectionOfFeatDataViewModel {
    var header: String
    var items: [Item]
}

extension SectionOfFeatDataViewModel: SectionModelType {
    typealias Item = FeatDataViewModel
    init(original: SectionOfFeatDataViewModel, items: [Item]) {
        self = original
        self.items = items
    }
}
