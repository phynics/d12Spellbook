//
//  FeatSourcePickerViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 11.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class FeatSourcePickerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var sourceDelegate: FeatSourcePickerDelegate?

    var shownFilter: FilterType = .source {
        didSet {
            tableView.reloadData()
        }
    }

    var sourceList: [String] = []
    var typeList: [String] = []
    
    
    var sourceListPicked: [String] = []
    var typeListPicked: [String] = []
    
    @IBAction func pickerChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            shownFilter = .source
        } else if sender.selectedSegmentIndex == 1 {
            shownFilter = .type
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        sourceList = sourceDelegate?.availableSources() ?? []
        typeList = sourceDelegate?.availableTypes() ?? []
        
        sourceListPicked = sourceDelegate?.pickedSources() ?? []
        typeListPicked = sourceDelegate?.pickedTypes() ?? []

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func toggleTypeState(At index: Int) {
        let type = self.typeList[index]
        if let foundIndex = self.typeListPicked.firstIndex(of: type) {
            self.typeListPicked.remove(at: foundIndex)
        } else {
            self.typeListPicked.append(type)
        }
    }
    
    func toggleSourceState(At index: Int) {
        let source = self.sourceList[index]
        if let foundIndex = self.sourceListPicked.firstIndex(of: source) {
            self.sourceListPicked.remove(at: foundIndex)
        } else {
            self.sourceListPicked.append(source)
        }
    }
}

extension FeatSourcePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var tableList: [String] = []

        switch shownFilter {
        case .source:
            tableList = self.sourceList
        case .type:
            tableList = self.typeList
        }

        return tableList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sourcePickerCell") as! FeatSourceListTableViewCell

        var tableList: [String] = []
        var tablePickedList: [String] = []

        switch shownFilter {
        case .source:
            tableList = self.sourceList
            tablePickedList = self.sourceListPicked
        case .type:
            tableList = self.typeList
            tablePickedList = self.typeListPicked
        }

        if indexPath.row > 0 {
            let cellName = tableList[indexPath.row - 1]
            cell.name = cellName
            cell.enabled = tablePickedList.contains(cellName)
        } else {
            if shownFilter == .source {
                cell.name = "All Sources"
                cell.enabled = tablePickedList.count == tableList.count
                    && tablePickedList.count > 0
            } else {
                cell.name = "All Types"
                cell.enabled = tablePickedList.count == tableList.count
                    && tablePickedList.count > 0
            }
        }
        return cell
    }


}

extension FeatSourcePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if shownFilter == .source {
                toggleSourceState(At: indexPath.row - 1)
            } else {
                toggleTypeState(At: indexPath.row - 1)
            }
            tableView.reloadData()
        } else if indexPath.row == 0 {
            if shownFilter == .source {
                if self.sourceListPicked.count == self.sourceList.count {
                    self.sourceListPicked = []
                } else {
                    self.sourceListPicked = self.sourceList
                }
            } else {
                if self.typeListPicked.count == self.typeList.count {
                    self.typeListPicked = []
                } else {
                    self.typeListPicked = self.typeList
                }
            }
            
            switch shownFilter {
            case .source:
                sourceDelegate?.onSourcePicked(self.sourceListPicked)
            case .type:
                sourceDelegate?.onTypePicked(self.typeListPicked)
            }
            tableView.reloadData()
        }
    }
}

protocol FeatSourcePickerDelegate {
    func onSourcePicked(_: [String])
    func onTypePicked(_: [String])
    
    func pickedSources() -> [String]
    func pickedTypes() -> [String]
    
    func availableSources() -> [String]
    func availableTypes() -> [String]
}

enum FilterType {
    case source
    case type
}

extension FilterType {
    var toggled: FilterType {
        if self == .source {
            return .type
        } else {
            return .source
        }
    }
}
