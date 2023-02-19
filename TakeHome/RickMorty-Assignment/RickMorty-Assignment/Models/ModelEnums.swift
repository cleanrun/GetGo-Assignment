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
}

enum Gender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case nonbinary = "Genderless"
    case unknown = "unknown"
}
