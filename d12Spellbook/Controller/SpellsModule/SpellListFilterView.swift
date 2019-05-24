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
import RxOptional

class SpellListFilterView: FormViewController {

    let disposeBag = DisposeBag()

    var dataSource: SpellListFilterViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()

        let classTitle = "Which classes do you want to see?"
        let componentTitle = "Which components do you want to see?"
        let schoolTitle = "Which schools do you want to see?"

        form +++ prepareMultipleChoiceSection(
            title: classTitle,
            options: dataSource.availableClassses(),
            state: dataSource.pickedClasses(),
            callback: { [weak self] result in self?.dataSource.onClassesPicked(result) }
        )
            +++ prepareMultipleChoiceSection(
                title: schoolTitle,
                options: dataSource.availableSchools(),
                state: dataSource.pickedSchools(),
                callback: { [weak self] result in self?.dataSource.onSchoolsPicked(result) }
            )
            +++ prepareMultipleChoiceSection(
                title: componentTitle,
                options: dataSource.availableComponents(),
                state: dataSource.pickedComponents(),
                callback: { [weak self] result in self?.dataSource.onComponentsPicked(result) }
            )

    }

    func prepareMultipleChoiceSection(title: String, options: [String], state: [String], callback: @escaping ([String]) -> Void) -> Section {
        let classesSection = SelectableSection<ListCheckRow<String>>(title, selectionType: .multipleSelection)

        let optionRows = options.map { option in
            ListCheckRow<String>(option) { listRow in
                listRow.title = option
                listRow.selectableValue = option
                listRow.value = state.contains(option) ? option : nil
            }
        }

        for row in optionRows {
            classesSection <<< row
        }

        let optionObservables = optionRows.map {
            $0.rx.value.asObservable()
        }

        Observable.combineLatest(optionObservables)
            .map { $0.filter { $0 != nil }.map { $0! } }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in callback(result) })
            .disposed(by: disposeBag)
        return classesSection
    }
}

protocol SpellListFilterViewDataSource {
    func availableClassses() -> [String]
    func pickedClasses() -> [String]

    func availableComponents() -> [String]
    func pickedComponents() -> [String]

    func availableSchools() -> [String]
    func pickedSchools() -> [String]

    func onClassesPicked(_: [String])
    func onComponentsPicked(_: [String])
    func onSchoolsPicked(_: [String])
}
