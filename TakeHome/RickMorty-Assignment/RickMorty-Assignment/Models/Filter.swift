//
//  Filter.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 23/02/23.
//

import Foundation

enum FilterType: String {
    case status = "status"
    case species = "species"
    case gender = "gender"
}

struct Filter: Identifiable, Hashable {
    let id = UUID()
    let type: FilterType
    let title: String
    let query: String
}

extension Filter {
    static func statusFilters() -> [Filter] {
        [
            Filter(type: .status, title: "Alive", query: "alive"),
            Filter(type: .status, title: "Dead", query: "dead"),
            Filter(type: .status, title: "Unknown", query: "unknown")
        ]
    }
    
    static func speciesFilters() -> [Filter] {
        [
            Filter(type: .species, title: "Alien", query: "alien"),
            Filter(type: .species, title: "Animal", query: "animal"),
            Filter(type: .species, title: "Mythological Creature", query: ""),
            Filter(type: .species, title: "Human", query: "human"),
        ]
    }
    
    static func genderFilters() -> [Filter] {
        [
            Filter(type: .species, title: "Male", query: "male"),
            Filter(type: .species, title: "Female", query: "female"),
            Filter(type: .species, title: "Genderless", query: "genderless"),
            Filter(type: .species, title: "Unknown", query: "unknown"),
        ]
    }
}
