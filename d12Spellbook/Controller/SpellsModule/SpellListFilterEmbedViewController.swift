//
//  SpellListFilterEmbedViewController.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 4.06.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import Eureka
import XLPagerTabStrip

class SpellFilterEmbedViewController: FormViewController, IndicatorInfoProvider {
    var indicatorTitle: String = "★"
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: indicatorTitle)
    }
}
