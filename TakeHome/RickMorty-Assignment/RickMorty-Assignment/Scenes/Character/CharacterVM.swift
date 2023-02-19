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
    
    @Published private(set) var characters = [Character]()
    @Published private(set) var isLoading = false
    @Published private(set) var errorState: Error? = nil
    private(set) var page = 0
    
    init(vc: CharacterVC) {
        self.viewController = vc
    }
    
    func getCharacters() {
        guard page != 10, errorState == nil else { return }
        page += 1
        Task {
            isLoading = true
            do {
                let retrievedCharacters = try await webservice.request(endpoint: .Characters, page: page, responseType: APIResponse<Character>.self)
                if page == 1 {
                    characters = retrievedCharacters.results
                } else {
                    characters += retrievedCharacters.results
                }
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
}
