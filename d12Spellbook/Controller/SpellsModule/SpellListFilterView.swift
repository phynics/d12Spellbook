//
//  SpellListFilterView.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 14.04.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import Eureka
import RxEureka
import RxSwift
import XLPagerTabStrip

class SpellListFilterView: SegmentedPagerTabStripViewController {

    let disposeBag = DisposeBag()

    var dataSource: SpellListFilterViewDataSource!
    
    var classesFilterViewController = SpellFilterEmbedViewController(style: .plain)
    var schoolFilterViewController = SpellFilterEmbedViewController(style: .plain)
    var componentsFilterViewController = SpellFilterEmbedViewController(style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        classesFilterViewController.form +++ prepareMultipleChoiceSection(
            options: dataSource.availableClassses(),
            state: dataSource.pickedClasses(),
            callback: { [weak self] result in self?.dataSource.onClassesPicked(result) }
        )
        classesFilterViewController.indicatorTitle = "Classes"
        
        schoolFilterViewController.form +++ prepareMultipleChoiceSection(
                options: dataSource.availableSchools(),
                state: dataSource.pickedSchools(),
                callback: { [weak self] result in self?.dataSource.onSchoolsPicked(result) }
            )
        schoolFilterViewController.indicatorTitle = "Schools"
        
        componentsFilterViewController.form +++ prepareComponentsSection(
                options: dataSource.availableComponents(),
                state: dataSource.pickedComponents(),
                filterOptions: dataSource.availableComponentsFilter(),
                filterState: dataSource.pickedComponentsFilter()
            )
        componentsFilterViewController.indicatorTitle = "Components"
        
        reloadPagerTabStripView()

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [classesFilterViewController, schoolFilterViewController, componentsFilterViewController]
    }

    func prepareMultipleChoiceSection(options: [String], state: [String], callback: @escaping ([String]) -> Void) -> Section {
        let section = SelectableSection<ListCheckRow<String>>("", selectionType: .multipleSelection)

        let optionRows = options.map { option in
            ListCheckRow<String>(option) { listRow in
                listRow.title = option
                listRow.selectableValue = option
                listRow.value = state.contains(option) ? option : nil
            }
        }

        for row in optionRows {
            section <<< row
        }

        let optionObservables = optionRows.map {
            $0.rx.value.asObservable()
        }

        Observable.combineLatest(optionObservables)
            .map { $0.filter { $0 != nil }.map { $0! } }
            .subscribe(onNext: { result in callback(result) })
            .disposed(by: disposeBag)
        return section
    }
    
    func prepareComponentsSection(options: [String], state: [String], filterOptions: [String], filterState: String) -> Section {
        let section = SelectableSection<ListCheckRow<String>>("", selectionType: .multipleSelection)
        
        let optionRows = options.map { option in
            ListCheckRow<String>(option) { listRow in
                listRow.title = option
                listRow.selectableValue = option
                listRow.value = state.contains(option) ? option : nil
            }
        }
        
        let segmentedRow = SegmentedRow<String>("filteringType") {
            $0.options = filterOptions
            $0.value = filterState
            }
        
        section <<< segmentedRow
        
        for row in optionRows {
            section <<< row
        }
        
        segmentedRow.rx.value.asObservable()
            .filter { $0 != nil }.map { $0! }
            .subscribe(onNext: {[weak self] result in self?.dataSource.onComponentsFilterPicked(result)})
            .disposed(by: disposeBag)
        
        let optionObservables = optionRows.map {
            $0.rx.value.asObservable()
        }
        
        Observable.combineLatest(optionObservables)
            .map { $0.filter { $0 != nil }.map { $0! } }
            .subscribe(onNext: {[weak self] result in self?.dataSource.onComponentsPicked(result) })
            .disposed(by: disposeBag)
        return section
    }
}

protocol SpellListFilterViewDataSource {
    func availableClassses() -> [String]
    func pickedClasses() -> [String]

    func availableComponents() -> [String]
    func pickedComponents() -> [String]
    
    func availableComponentsFilter() -> [String]
    func pickedComponentsFilter() -> String

    func availableSchools() -> [String]
    func pickedSchools() -> [String]

    func onClassesPicked(_: [String])
    func onComponentsFilterPicked(_: String)
    func onComponentsPicked(_: [String])
    func onSchoolsPicked(_: [String])
}
