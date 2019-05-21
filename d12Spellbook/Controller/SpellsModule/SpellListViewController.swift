//
//  SpellListViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 26.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class SpellListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var dataController: DataController?
    var spells = BehaviorSubject<[SpellDataViewModel]>(value: [])
    var spellClasses = BehaviorSubject<[String]>(value: [])
    var spellClassesFilter = BehaviorSubject<[String]>(value: [])
    var disposeBag = DisposeBag()

    
    @IBAction func onFilterButtonSelected(_ sender: Any) {
        performSegue(withIdentifier: "spellFilter", sender: nil)
    }
    
    override func viewDidLoad() {
        if let dataController = self.dataController { // set up behaviorsubjects
            dataController.spells
                .subscribe(self.spells.asObserver())
                .disposed(by: disposeBag)
            dataController.spellClasses
                .subscribe(self.spellClasses.asObserver())
                .disposed(by: disposeBag)
        }
        
        let searchResult = self.searchBar.rx.text // retrieve searchbar results
            .orEmpty
            .distinctUntilChanged()
            .debounce(0.5, scheduler: MainScheduler.instance)
        
        Observable.combineLatest(searchResult, spells, spellClassesFilter) { (searchText, spellsList, filter) -> [SpellDataViewModel] in // combine and filter from data sources
            var spells = spellsList
            if filter.count > 0 {
                spells = spells.filter({ (model) -> Bool in
                    print("1\(model.viewCastingClasses)")
                    print("2\(filter)")
                    let result = model.viewCastingClasses.contains { (cls) -> Bool in
                        return filter.contains(cls)
                    }
                    print(result)
                    return result
                })
                print(spells)
            }
            
            spells = spells.filter {
                $0.viewName.lowercased().contains(searchText.lowercased())
            }
            return spells
        }
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "spellCell")) { (index, item, cell) in
                let spellCell = cell as? SpellListTableViewCell
                spellCell?.spell = item
        }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SpellDataViewModel.self)
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] model in
                guard let strongSelf = self else {
                    return
                }
                guard let detailVC = strongSelf.storyboard?
                    .instantiateViewController(withIdentifier: "SpellDetailViewController") as? SpellListDetailView else {
                        return
                }

                strongSelf.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SpellListFilterView {
            destination.dataSource = self
        }
    }
}

extension SpellListViewController: SpellListFilterViewDataSource {
    func availableClassses() -> [String] {
       return try! spellClasses.value()
    }
    
    func pickedClasses() -> [String] {
        return try! spellClassesFilter.value()
    }
    
    func onClassesPicked(_ list: [String]) {
        spellClassesFilter.onNext(list)
    }
    
}

struct LevelSectionOfSpellData {
    var header: String
    var items: [SpellDataViewModel]
}

extension LevelSectionOfSpellData: SectionModelType {
    typealias  Item = SpellDataViewModel
    
    init(original: LevelSectionOfSpellData, items: [Item]) {
        self = original
        self.items = items
    }
}
