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

class SpellListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataController: DataController?
    var spells = BehaviorSubject<[SpellDataViewModel]>(value: [])
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        spells.observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "spellCell")) { index, model, cell in
                if let spellCell = cell as? SpellListTableViewCell {
                    spellCell.spell = model
                }
            }
            .disposed(by: disposeBag)

        if let dataController = self.dataController {
            dataController.fetchSpellsUpdating()
                .subscribe(self.spells.asObserver())
                .disposed(by: disposeBag)
        }
    }
}
