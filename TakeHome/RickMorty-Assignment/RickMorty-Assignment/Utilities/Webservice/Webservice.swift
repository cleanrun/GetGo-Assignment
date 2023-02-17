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
    case Characters = "https://rickandmortyapi.com/api/character/?page="
    case Locations = "https://rickandmortyapi.com/api/location?page="
    case Episodes = "https://rickandmortyapi.com/api/episode?page="
}

enum WebserviceError: Error {
    case invalidURL
    case responseError
}

final class Webservice {
    func request<T: Decodable>(endpoint: Endpoint, page: Int = 1, responseType: T.Type) async throws -> T {
        if let url = URL(string: "\(endpoint.rawValue)\(page)") {
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
    }
}
