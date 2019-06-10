//
//  AboutViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 10.06.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let data = [
        AboutViewModel.PaizoCommunityUse,
        AboutViewModel.RxSwift,
        AboutViewModel.CoreStore,
        AboutViewModel.RxCoreStore,
        AboutViewModel.Eureka,
        AboutViewModel.RxEureka,
        AboutViewModel.RxDataStores,
        AboutViewModel.XLPagerTabStrip
    ]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AboutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell") as? AboutTableViewCell
        cell?.source = data[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? AboutTableViewCell
        cell?.toggleState()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
