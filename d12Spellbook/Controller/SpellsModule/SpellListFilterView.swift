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
        
        let classesSection = SelectableSection<ListCheckRow<String>>("Which classes do you want to see?", selectionType: .multipleSelection)
        
        let optionList = dataSource.availableClassses()
        let state = dataSource.pickedClasses()
        
        let optionRows = optionList.map { option in
            ListCheckRow<String>(option) { listRow in
                listRow.title = option
                listRow.selectableValue = option
                listRow.value = state.contains(option) ? option : nil
            }
        }
        
        form +++ classesSection
        for row in optionRows {
            classesSection <<< row
        }
        
        let optionObservables = optionRows.map {
            $0.rx.value.asObservable()
        }
        
        Observable.combineLatest(optionObservables)
            .map { $0.filter { $0 != nil }.map { $0! } }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in self?.dataSource.onClassesPicked(result) })
            .disposed(by: disposeBag)
    }
}

protocol SpellListFilterViewDataSource {
    func availableClassses() -> [String]
    func pickedClasses() -> [String]
    
    func onClassesPicked(_: [String])
}
