//
//  ViewController.swift
//  FeatList
//
//  Created by Atakan Dulker on 25.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import UIKit
import Foundation

class FeatListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var featList: FeatCardList?

    override func viewDidLoad() {
        super.viewDidLoad()
        _loadFeatList()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func _loadFeatList() {
        let resourceName = "FeatPFRPG-CORE"
        if let path = Bundle.main.url(forResource: resourceName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: path)
                featList = try FeatCardList(withData: data)
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeatCardDetailViewController {
            if let selected = tableView.indexPathForSelectedRow?.row {
                vc.sourceFeat = self.featList![selected]
            }
        }
    }

}

extension FeatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.featList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "featListCellPrototype") as! FeatListTableViewCell
        let feat = self.featList?[indexPath.row]
        if let feat = feat {
                cell.title = feat.title
                cell.desc = feat.shortDescription
            }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showFeatDetail", sender: nil)
    }
}
