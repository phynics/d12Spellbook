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

    let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

    var dataController: DataController?
    var spells = BehaviorSubject<[SpellDataViewModel]>(value: [])
    var spellClassesFilter = BehaviorSubject<[String]>(value: [])
    var spellSchoolsFilter = BehaviorSubject<[String]>(value: [])
    var spellComponentsFilter = BehaviorSubject<[String]>(value: [])
    var disposeBag = DisposeBag()


    @IBAction func onFilterButtonSelected(_ sender: Any) {
        performSegue(withIdentifier: "spellFilter", sender: nil)
    }

    override func viewDidLoad() {
        if let dataController = self.dataController { // set up behaviorsubjects
            dataController.spells
                .subscribe(self.spells.asObserver())
                .disposed(by: disposeBag)
        }
        
        
        let tableDataSource = RxTableViewSectionedReloadDataSource<LevelSectionOfSpellData>(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "spellCell") as? SpellListTableViewCell
            cell?.spell = item
            return cell!
        })
        
        tableDataSource.sectionIndexTitles = { [weak self] arg in
            if let classFilter = try? self?.spellClassesFilter.value() {
                if classFilter.count == 1 {
                    return arg.sectionModels.map {
                        $0.header
                    }
                }
            }
            return []
        }
        
        tableDataSource.titleForHeaderInSection = { dataSource, index in "Level \(dataSource.sectionModels[index].header)" }

        let searchResult = self.searchBar.rx.text // retrieve searchbar results
        .orEmpty
            .distinctUntilChanged()
            .debounce(0.5, scheduler: backgroundScheduler)

        Observable.combineLatest(searchResult, spells, spellClassesFilter, spellComponentsFilter, spellSchoolsFilter)
        { (searchText, spellsList, classFilter, componentFilter, schoolFilter) -> [LevelSectionOfSpellData] in // combine and filter from data sources
            var spells = spellsList

            if classFilter.count > 0 {
                spells = spells.filter { (model) -> Bool in
                    model.viewCastingClasses
                        .filter { $0.spellLevel >= 0 }
                        .contains(where: { (ccsl) -> Bool in
                            return classFilter.contains(ccsl.castingClass.rawValue)
                        })
                }
            }
            
            if schoolFilter.count > 0 {
                spells = spells.filter { (model) -> Bool in
                    return schoolFilter.contains(model.viewSchool.rawValue)
                }
            }

            if searchText.count > 0 {
                spells = spells.filter {
                    $0.viewName.lowercased().contains(searchText.lowercased())
                }
            }
            
            if classFilter.count == 1 {
                return Dictionary.init(grouping: spells, by: { spell in
                    spell.viewCastingClasses
                        .first(where: { $0.castingClass.rawValue == classFilter.first!})
                        .map { $0.spellLevel }
                })
                    .map { (arg) -> LevelSectionOfSpellData in
                        var (key, value) = arg
                        value.sort(by: { a, b in a.viewSchoolsWithDescriptors.lexicographicallyPrecedes(b.viewSchoolsWithDescriptors) })
                        return LevelSectionOfSpellData(header: String(describing: key ?? 0), items: value)
                    }
                    .sorted(by: { (a, b) -> Bool in
                        return a.header.lexicographicallyPrecedes(b.header)
                    })
            }
            return [LevelSectionOfSpellData(header: "", items: spells)]
        }
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: tableDataSource))
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
    func availableComponents() -> [String] {
        return CastingComponent.allCases.map { $0.rawValue }
    }

    func pickedComponents() -> [String] {
        return try! spellSchoolsFilter.value()
    }

    func availableSchools() -> [String] {
        return CastingSchool.allCases.map { $0.rawValue }
    }

    func pickedSchools() -> [String] {
        return try! spellSchoolsFilter.value()
    }

    func availableClassses() -> [String] {
        return CastingClass.allCases.map { (option: CastingClass) in option.rawValue }
    }

    func pickedClasses() -> [String] {
        return try! spellClassesFilter.value()
    }

    func onClassesPicked(_ list: [String]) {
        spellClassesFilter.onNext(list)
    }

    func onComponentsPicked(_ list: [String]) {
        spellComponentsFilter.onNext(list)
    }

    func onSchoolsPicked(_ list: [String]) {
        spellSchoolsFilter.onNext(list)
    }

}

struct LevelSectionOfSpellData {
    var header: String
    var items: [SpellDataViewModel]
}

extension LevelSectionOfSpellData: SectionModelType {
    typealias Item = SpellDataViewModel

    init(original: LevelSectionOfSpellData, items: [Item]) {
        self = original
        self.items = items
    }
}
