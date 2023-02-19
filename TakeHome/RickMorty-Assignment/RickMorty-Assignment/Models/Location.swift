//
//  Location.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation

struct Location: Decodable, Hashable {
    let locationId: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
    
    private enum CodingKeys: String, CodingKey {
        case locationId = "id"
        case name
        case type
        case dimension
        case residents
        case url
        case created
    }
}
