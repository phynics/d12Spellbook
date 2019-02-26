//
//  FeatCard.swift
//  FeatList
//
//  Created by Atakan Dulker on 25.02.2019.
//  Copyright © 2019 atakan. All rights reserved.
//

import Foundation

class FeatCardList {
    private let _feats: [FeatCardCodable]
    
    subscript(index: Int) -> FeatCardCodable? {
        get {
            if index < self._feats.count {
                return self._feats[index]
            } else {
                return Optional<FeatCardCodable>.none
            }
        }
    }
    
    var count: Int {
        get {
            return self._feats.count
        }
    }
    
    init(withData data: Data) throws {
        let decoder = JSONDecoder()
        self._feats = try decoder.decode([FeatCardCodable].self, from: data)
    }
    
}

struct FeatCardCodable {
    var count: Int
    var color: String
    var title: String
    var icon: String
    var iconBack: String
    var tags: [String]
    
    
    var featType: String
    var prereqs: String
    var shortDescription: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case iconBack = "icon_back"
        
        case count
        case color
        case title
        case icon
        case tags
        case contents
    }
}

extension FeatCardCodable: Decodable {
    init(from decoder: Decoder) throws {
        let FEAT_TYPE_PREFIX = "subtitle | "
        let PREREQ_PREFIX = "property | prerequisites | "
        let DESC_PREFIX = "text | "
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey:.count)
        color = try values.decode(String.self, forKey:.color)
        title = try values.decode(String.self, forKey:.title)
        icon = try values.decode(String.self, forKey:.icon)
        iconBack = try values.decode(String.self, forKey:.iconBack)
        tags = try values.decode([String].self, forKey:.tags)
        
        let contents = try values.decode([String].self, forKey:.contents)
        featType = contents.first(where:) { $0.hasPrefix(FEAT_TYPE_PREFIX) }!
            .replacingOccurrences(of: FEAT_TYPE_PREFIX, with: "")
        prereqs = contents.first(where:) { $0.hasPrefix(PREREQ_PREFIX) }!
            .replacingOccurrences(of: PREREQ_PREFIX, with: "")
        shortDescription = contents.first(where:) { $0.hasPrefix(DESC_PREFIX) }!
            .replacingOccurrences(of: DESC_PREFIX, with: "")
        description = contents.last(where:) { $0.hasPrefix(DESC_PREFIX) }!
            .replacingOccurrences(of: DESC_PREFIX, with: "")
        
        
    }
}
