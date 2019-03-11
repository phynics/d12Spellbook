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
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

protocol FeatSourcePickerDelegate {
    func numberOfSources() -> Int
    func sourceAtIndex(index: Int) -> (name: String, picked: Bool)
    func changed(atIndex: Int)
}

extension FeatSourcePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceDelegate?.numberOfSources() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sourcePickerCell")
        if let cell = cell as? FeatSourceListTableViewCell {
            let cellData = self.sourceDelegate?.sourceAtIndex(index: indexPath.row)
            cell.name = cellData?.name
            cell.enabled = cellData?.picked
        }
        return cell!
    }
    
    
}

extension FeatSourcePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sourceDelegate?.changed(atIndex: indexPath.row)
        self.tableView.reloadData()
    }
}
