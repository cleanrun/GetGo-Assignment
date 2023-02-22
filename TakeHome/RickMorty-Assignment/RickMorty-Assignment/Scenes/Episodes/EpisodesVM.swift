//
//  EpisodesVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation
import Combine

final class EpisodesVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: EpisodesVC?
    
    private var allEpisodes = [Episode]()
    @Published private(set) var episodes = [Episode]()
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    @Published private(set) var searchQuery: String? = nil
    private(set) var page = 0
    
    init(vc: EpisodesVC) {
        self.viewController = vc
    }
    
    func getEpisodes() {
        guard page != 10, errorState == nil else { return }
        page += 1
        Task {
            isLoading = true
            do {
                let retrievedEpisodes = try await webservice.request(endpoint: .Episodes, page: page, responseType: APIResponse<Episode>.self)
                if page == 1 {
                    allEpisodes = retrievedEpisodes.results
                } else {
                    allEpisodes += retrievedEpisodes.results
                }
                episodes = allEpisodes
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
    
    func setSearchQuery(_ query: String) {
        searchQuery = query.isEmpty ? nil : query
    }
    
    func filterEpisodesByQuery() {
        if let searchQuery {
            let filteredLocations = allEpisodes.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
            episodes = filteredLocations
        } else {
            episodes = allEpisodes
        }
    }
}

