//
//  Episode.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation

struct Episode: Decodable, Hashable {
    let episodeId: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    private enum CodingKeys: String, CodingKey {
        case episodeId = "id"
        case name
        case airDate = "air_date"
        case episode
        case characters
        case url
        case created
    }
}
