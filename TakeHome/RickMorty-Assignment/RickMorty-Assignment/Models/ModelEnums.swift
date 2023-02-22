//
//  ModelEnums.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import Foundation

enum Status: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var icon: String {
        switch self {
        case .alive:
            return ImageAsset.IC_ALIVE
        case .dead:
            return ImageAsset.IC_DEAD
        case .unknown:
            return ImageAsset.IC_UNKNOWN
        }
    }
}

enum Gender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    
    var icon: String {
        switch self {
        case .female:
            return ImageAsset.IC_FEMALE
        case .male:
            return ImageAsset.IC_MALE
        case .genderless:
            return ImageAsset.IC_GENDERLESS
        case .unknown:
            return ImageAsset.IC_UNKNOWN
        }
    }
}
