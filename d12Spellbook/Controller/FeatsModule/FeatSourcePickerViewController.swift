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

    var sourceList: [FeatListViewController.FeatToggle]?
    var typeList: [FeatListViewController.FeatToggle]?

    var pickAllSources: Bool {
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

    var pickAllTypes: Bool {
        get {
            if let typeList = self.typeList,
                typeList.allSatisfy({ $0.picked }) {
                return true
            } else {
                return false
            }
        }
        set {
            for index in 0..<(typeList?.count ?? 0) {
                toggleTypeState(index, to: newValue)
            }
        }
    }

    override func viewDidLoad() {
        sourceList = sourceDelegate?.retrieveSourceState()
        typeList = sourceDelegate?.retrieveTypeState()

        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func pickerChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            shownFilter = .source
        } else if sender.selectedSegmentIndex == 1 {
            shownFilter = .type
        }
    }

    @IBAction func dismissView(_ sender: Any) {
        if let sourceList = self.sourceList,
            let typeList = self.typeList {
            sourceDelegate?.lastState(types: typeList, sources: sourceList)
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

    func toggleTypeState(_ index: Int, to: Bool?) {
        if let item = typeList?[index] {
            if let toBool = to {
                typeList![index] = (name: item.name, picked: toBool)
            } else {
                typeList![index] = (name: item.name, picked: !item.picked)
            }
        }
    }
}

extension FeatSourcePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var tableList: [FeatListViewController.FeatToggle]? = []

        switch shownFilter {
        case .source:
            tableList = self.sourceList
        case .type:
            tableList = self.typeList
        }

        if let count = tableList?.count {
            return count + 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "sourcePickerCell") as! FeatSourceListTableViewCell

        var tableList: [FeatListViewController.FeatToggle]? = []

        switch shownFilter {
        case .source:
            tableList = self.sourceList
        case .type:
            tableList = self.typeList
        }

        if indexPath.row > 0 {
            let cellData = tableList?[indexPath.row - 1]
            cell.name = cellData?.name
            cell.enabled = cellData?.picked
        } else {
            if shownFilter == .source {
                cell.name = "All Sources"
                cell.enabled = pickAllSources
            } else {
                cell.name = "All Types"
                cell.enabled = pickAllTypes
            }
        }

        return cell
    }


}

extension FeatSourcePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if shownFilter == .source {
                toggleSourceState(indexPath.row - 1, to: nil)
            } else {
                toggleTypeState(indexPath.row - 1, to: nil)
            }
            tableView.reloadData()
        } else {
            if shownFilter == .source {
                pickAllSources.toggle()
            } else {
                pickAllTypes.toggle()
            }
            tableView.reloadData()
        }
    }
}


protocol FeatSourcePickerDelegate {
    func retrieveSourceState() -> [FeatListViewController.FeatToggle]
    func retrieveTypeState() -> [FeatListViewController.FeatToggle]
    func lastState(types: [FeatListViewController.FeatToggle], sources: [FeatListViewController.FeatToggle])
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
