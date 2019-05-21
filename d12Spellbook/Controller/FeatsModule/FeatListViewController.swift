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


    var dataController: DataController?
    let disposeBag = DisposeBag()

    typealias FeatToggle = (name: String, picked: Bool)

    var featSources = BehaviorSubject(value: [FeatToggle]())
    var featTypes = BehaviorSubject(value: [FeatToggle]())

    let refreshData = ReplaySubject<Void>.create(bufferSize: 1)

    @IBAction func filterButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "filterPopUp", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardOnTouch()
        
        let tableDataSource = RxTableViewSectionedReloadDataSource<SectionOfFeatDataViewModel>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "featCell")
            if let cell = cell as? FeatListTableViewCell {
                cell.sourceFeat = item
            }
            return cell!
        })
        
        tableDataSource.sectionIndexTitles = { arg in
            arg.sectionModels.map { $0.header }
        }

        refreshData.onNext(())
        refreshData.flatMap {
            self.searchBar.rx.text
                .orEmpty
                .distinctUntilChanged()
                .debounce(0.5, scheduler: MainScheduler.instance)
        }
            .flatMap { [weak self] (searchText) -> Observable<[FeatDataViewModel]> in
                if let dataSource = self?.dataController {
                    let sourceFilter = try? self?.featSources.value()
                        .filter {
                            $0.picked
                        }
                        .map {
                            $0.name
                    }
                    let typeFilter = try? self?.featTypes.value()
                        .filter {
                            $0.picked
                        }
                        .map {
                            $0.name
                    }
                    return dataSource.feats(FromSources: sourceFilter, WithTypes: typeFilter)
                        .map {
                            return $0.filter {
                                if searchText.count > 0 {
                                    return $0.viewName.contains(searchText)
                                } else {
                                    return true
                                }
                            }
                    }
                } else {
                    return Observable<[FeatDataViewModel]>.empty()
                }
            }
            .map { featModels in
                return Dictionary.init(grouping: featModels, by: { $0.viewName.first! })
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

        if let dataSource = dataController {
            dataSource.featSources
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
                .map {
                    $0.map {
                        (name: $0, picked: true)
                    }
                }
                .subscribe(self.featSources)
                .disposed(by: disposeBag)

            dataSource.feats.map {
                $0.map { feat -> [String] in
                    let additionalTypes = feat.viewTypes
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
                .map {
                    $0.map {
                        (name: $0, picked: true)
                    }
                }
                .subscribe(self.featTypes.asObserver())
                .disposed(by: disposeBag)

            self.tableView.rx.itemSelected.subscribe { [weak self] event in
                self?.performSegue(withIdentifier: "showFeatDetail", sender: nil)
            }
                .disposed(by: disposeBag)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeatCardDetailViewController {
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
    func lastState(types: [FeatListViewController.FeatToggle], sources: [FeatListViewController.FeatToggle]) {
        self.featSources.onNext(sources)
        self.featTypes.onNext(types)
        self.refreshData.onNext(())
    }

    func retrieveSourceState() -> [FeatListViewController.FeatToggle] {
        if let vl = try? self.featSources.value() {
            return vl
        } else {
            return []
        }
    }

    func retrieveTypeState() -> [FeatListViewController.FeatToggle] {
        if let vl = try? self.featTypes.value() {
            return vl
        } else {
            return []
        }
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
