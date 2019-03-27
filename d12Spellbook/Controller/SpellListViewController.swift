//
//  SpellListViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 26.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class SpellListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataController: DataController?
    var spells: [SpellDataViewModel]?
    
    override func viewDidLoad() {
        dataController?.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        spells = dataController?.fetchSpells()
        tableView.reloadData()
    }
}

extension SpellListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spells?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spellCell") as! SpellListTableViewCell
        if let spells = self.spells {
            cell.spell = spells[indexPath.row]
        }
        return cell
    }
    
    
}

extension SpellListViewController: DataControllerDelegate {
    func onDataUpdated(_: updateType) {
        loadData()
    }
}
