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
    
    @Published private(set) var episodes = [Episode]()
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    private var page = 1
    
    init(vc: EpisodesVC) {
        self.viewController = vc
    }
    
    func getEpisodes() {
        Task {
            isLoading = true
            do {
                let retrievedEpisodes = try await webservice.request(endpoint: .Episodes, responseType: APIResponse<Episode>.self)
                episodes = retrievedEpisodes.results
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
}

