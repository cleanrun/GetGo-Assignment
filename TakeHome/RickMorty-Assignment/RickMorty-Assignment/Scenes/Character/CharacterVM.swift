//
//  CharacterVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import Foundation
import Combine

final class CharacterVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: CharacterVC?
    
    private var allCharacters = [Character]()
    @Published private(set) var characters = [Character]()
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    @Published private(set) var searchQuery: String? = nil
    private var filters: [Filter]? = nil
    private(set) var page = 0
    
    init(vc: CharacterVC) {
        self.viewController = vc
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter(_:)), name: kPostFilterNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: kPostFilterNotification, object: nil)
    }
    
    func getCharacters() {
        guard page != 10, errorState == nil else { return }
        page += 1
        Task {
            isLoading = true
            do {
                let retrievedCharacters = try await webservice.request(endpoint: .Characters, page: page, filter: filters, responseType: APIResponse<Character>.self)
                if page == 1 {
                    allCharacters = retrievedCharacters.results
                } else {
                    allCharacters += retrievedCharacters.results
                }
                characters = allCharacters
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
    
    func filterCharactersByQuery() {
        if let searchQuery {
            let filteredLocations = allCharacters.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
            characters = filteredLocations
        } else {
            characters = allCharacters
        }
    }
    
    @objc func applyFilter(_ notification: Notification) {
        filters = notification.object as? [Filter]
        allCharacters.removeAll()
        characters.removeAll()
        page = 0
        errorState = nil
        getCharacters()
    }
}
