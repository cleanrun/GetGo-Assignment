//
//  LocationVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import Foundation
import Combine

final class LocationVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: LocationVC?
    
    @Published private(set) var locations = [Location]()
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    private(set) var page = 0
    
    init(vc: LocationVC) {
        self.viewController = vc
    }
    
    func getLocations() {
        guard page != 10, errorState == nil else { return }
        page += 1
        Task {
            isLoading = true
            do {
                let retrievedLocations = try await webservice.request(endpoint: .Locations, page: page, responseType: APIResponse<Location>.self)
                if page == 1 {
                    locations = retrievedLocations.results
                } else {
                    locations += retrievedLocations.results
                }
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
}
