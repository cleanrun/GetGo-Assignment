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
                    episodes = retrievedEpisodes.results
                } else {
                    episodes += retrievedEpisodes.results
                }
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
}

