//
//  Character.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation

struct Character: Decodable {
    let charId: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Basic
    let location: Basic
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    private enum CodingKeys: String, CodingKey {
        case charId = "id"
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
}