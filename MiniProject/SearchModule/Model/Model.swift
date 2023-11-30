//
//  Model.swift
//  MiniProject
//
//  Created by reyhan muhammad on 11/08/23.
//

import Foundation

class ModelContainer: Codable{
    var data: Categories?
}

class Categories: Codable{
    var categories: [Category]?
}

class Category: Codable{
    var id: String?
    var name: String?
    var identifier: String?
    var url: String?
    var iconImageUrl: String?
    var child: [Category]?
    var isExpanded: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, name, identifier, url, child
        case iconImageUrl = "icon_image_url"
    }
    
    // Encode and decode methods
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode all properties as usual
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        iconImageUrl = try container.decodeIfPresent(String.self, forKey: .iconImageUrl)
        child = try container.decodeIfPresent([Category].self, forKey: .child)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // Encode all properties as usual
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(identifier, forKey: .identifier)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(iconImageUrl, forKey: .iconImageUrl)
        try container.encodeIfPresent(child, forKey: .child)
    }
}
