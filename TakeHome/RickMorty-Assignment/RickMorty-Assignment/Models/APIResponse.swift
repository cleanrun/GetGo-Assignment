//
//  WebResponse.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String?
}

struct APIResponse<T: Decodable>: Decodable {
    let info: Info
    let results: [T]
}
