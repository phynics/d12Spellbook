//
//  FeatCard.swift
//  FeatList
//
//  Created by Atakan Dulker on 25.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

class FeatCardList {
    let feats: [FeatCardCodable]
    init(withData data: Data) throws {
        let decoder = JSONDecoder()
        self.feats = try decoder.decode([FeatCardCodable].self, from: data)
    }
    
}

struct FeatCardCodable: Codable {
    var count: Int
    var color: String
    var icon: String
    var iconBack: String
    var contents: [String]
    var tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case iconBack = "icon_back"
        
        case count
        case color
        case icon
        case contents
        case tags
    }
}
