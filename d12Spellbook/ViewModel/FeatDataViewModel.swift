//
//  FeatDataViewModel.swift
//  d12Spellbook
//
//  Created by Atakan Dulker on 3.03.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation
import UIKit

class FeatDataViewModel {
    let name: String
    let shortDescription: String
    let description: NSAttributedString
    let prerequisites: NSAttributedString
    let sourceName: String
    let type: String
    let additionalType: String
    
    init(name: String, shortDescription: String, description: NSAttributedString, prerequisites: NSAttributedString, sourceName: String, type: String, additionalType: String = "") {
        self.name = name
        self.shortDescription = shortDescription
        self.description = description
        self.prerequisites = prerequisites
        self.sourceName = sourceName
        self.type = type
        self.additionalType = additionalType
    }
    
    
    private static func _convertFrom(jsonData: FeatDataModelPfCommunity) -> FeatDataViewModel {
        let fontAttributes: [NSAttributedString.Key : Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 16)!]
        let benefitText = NSMutableAttributedString(string: "Benefit: ", attributes: fontAttributes)
        let normalText = NSMutableAttributedString(string: "Normal: ", attributes: fontAttributes)
        let specialText = NSMutableAttributedString(string: "Special: ", attributes: fontAttributes)
        let goalText = NSMutableAttributedString(string: "Goal: ", attributes: fontAttributes)
        let completionText = NSMutableAttributedString(string: "Completion Benefit: ", attributes: fontAttributes)
        let noteText = NSMutableAttributedString(string: "Note: ", attributes: fontAttributes)
        let spacing = NSMutableAttributedString(string: "\n\n")
        
        let description = NSMutableAttributedString(string: "")
        if(jsonData.benefit.count > 0) {
            description.append(benefitText)
            description.append(NSMutableAttributedString(string: jsonData.benefit))
            description.append(spacing)
        }
        if(jsonData.normal.count > 0) {
            description.append(normalText)
            description.append(NSMutableAttributedString(string: jsonData.normal))
            description.append(spacing)
        }
        if(jsonData.special.count > 0) {
            description.append(specialText)
            description.append(NSMutableAttributedString(string: jsonData.special))
            description.append(spacing)
        }
        if(jsonData.goal.count > 0) {
            description.append(goalText)
            description.append(NSMutableAttributedString(string: jsonData.goal))
            description.append(spacing)
        }
        if(jsonData.completionBenefit.count > 0) {
            description.append(completionText)
            description.append(NSMutableAttributedString(string: jsonData.completionBenefit))
            description.append(spacing)
        }
        if(jsonData.note.count > 0) {
            description.append(noteText)
            description.append(NSMutableAttributedString(string: jsonData.note))
            description.append(spacing)
        }
        
        let prerequisitesText = NSMutableAttributedString(string: "Prerequisites: ", attributes: fontAttributes)
        prerequisitesText.append(NSMutableAttributedString(string: jsonData.prerequisites))
        
        return FeatDataViewModel(name: jsonData.name, shortDescription: jsonData.description, description: description, prerequisites: prerequisitesText, sourceName: jsonData.sourceName, type: jsonData.type)
    }
    
    static func fromData(_ data: Data) throws -> [FeatDataViewModel] {
        let decoder = JSONDecoder()
        let rawDecode = try decoder.decode([String:FeatDataModelPfCommunity].self, from: data)
        let featList = Array(rawDecode.values).sorted(by: { (a, b) -> Bool in
            return a.name.lexicographicallyPrecedes(b.name)
        })
        return featList.map { self._convertFrom(jsonData: $0) }
    }
    
}
