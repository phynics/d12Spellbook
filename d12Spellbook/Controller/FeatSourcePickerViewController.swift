//
//  FeatSourcePickerViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 11.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class FeatSourcePickerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sourceDelegate: FeatSourcePickerDelegate?
    
    var sourceList: [FeatListViewController.FeatSourceUse]?
    
    override func viewDidLoad() {
        sourceList = sourceDelegate?.retrieveSourceState()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func dismissView(_ sender: Any) {
        if let sourceList = self.sourceList {
            sourceDelegate?.lastSourceState(sourceList)
        }
        self.dismiss(animated: true)
    }
    
    func toggleSourceState(_ index: Int) {
        if let item = sourceList?[index] {
            sourceList![index] = (name: item.name, picked: !item.picked)
        }
    }
}

extension FeatSourcePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sourcePickerCell") as! FeatSourceListTableViewCell
        
        let cellData = sourceList?[indexPath.row]
        cell.name = cellData?.name
        cell.enabled = cellData?.picked
        
        return cell
    }
    
    
}

extension FeatSourcePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleSourceState(indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


protocol FeatSourcePickerDelegate {
    func lastSourceState(_: [FeatListViewController.FeatSourceUse])
    func retrieveSourceState() -> [FeatListViewController.FeatSourceUse]?
}
