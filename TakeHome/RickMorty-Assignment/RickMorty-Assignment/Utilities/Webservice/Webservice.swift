//
//  Webservice.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation

struct WebserviceDependencyKey: DependencyKey {
    static var currentValue: Webservice = Webservice()
}

enum Endpoint: String {
    case Characters = "https://rickandmortyapi.com/api/character"
    case Locations = "https://rickandmortyapi.com/api/location"
    case Episodes = "https://rickandmortyapi.com/api/episode"
}

enum WebserviceError: Error {
    case invalidURL
    case responseError
}

final class Webservice {
    func request<T: Decodable>(endpoint: Endpoint, page: Int = 1, filter: [Filter]? = nil, responseType: T.Type) async throws -> T {
        let pageQueryItem = [URLQueryItem(name: "page", value: String(page))]
        
        if var urlComponents = URLComponents(string: "\(endpoint.rawValue)") {
            if filter != nil {
                let queryItems = filter!.map { URLQueryItem(name: $0.type.rawValue, value: $0.query) }
                urlComponents.queryItems = pageQueryItem + queryItems
            } else {
                urlComponents.queryItems = pageQueryItem
            }
            
            if let url = urlComponents.url {
                let request = URLRequest(url: url)
                let task = try await URLSession.shared.data(for: request)
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: task.0)
                    return decodedData
                } catch {
                    throw WebserviceError.responseError
                }
            } else {
                throw WebserviceError.invalidURL
            }
        } else {
            throw WebserviceError.invalidURL
        }
    }
}
