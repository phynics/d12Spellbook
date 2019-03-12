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
    
    var pickAll: Bool {
        get {
            if let sourceList = self.sourceList,
                sourceList.allSatisfy({ $0.picked }) {
                return true
            } else {
                return false
            }
        }
        set {
            for index in 0..<(sourceList?.count ?? 0) {
                toggleSourceState(index, to: newValue)
            }
        }
    }
    
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
    
    func toggleSourceState(_ index: Int, to: Bool?) {
        if let item = sourceList?[index] {
            if let toBool = to {
                sourceList![index] = (name: item.name, picked: toBool)
            } else {
                sourceList![index] = (name: item.name, picked: !item.picked)
            }
        }
    }
}

extension FeatSourcePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = sourceList?.count {
            return count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sourcePickerCell") as! FeatSourceListTableViewCell
        
        if indexPath.row > 0 {
            let cellData = sourceList?[indexPath.row-1]
            cell.name = cellData?.name
            cell.enabled = cellData?.picked
        } else {
            cell.name = "All Sources"
            cell.enabled = pickAll
        }
        
        return cell
    }
    
    
}

extension FeatSourcePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            toggleSourceState(indexPath.row-1, to: nil)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            pickAll.toggle()
            tableView.reloadData()
        }
    }
}


protocol FeatSourcePickerDelegate {
    func lastSourceState(_: [FeatListViewController.FeatSourceUse])
    func retrieveSourceState() -> [FeatListViewController.FeatSourceUse]?
}
