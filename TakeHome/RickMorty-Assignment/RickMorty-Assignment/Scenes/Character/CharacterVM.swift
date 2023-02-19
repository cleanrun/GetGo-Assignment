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
    private var page = 1
    
    init(vc: CharacterVC) {
        self.viewController = vc
    }
    
    func getCharacters() {
        Task {
            isLoading = true
            do {
                let retrievedCharacters = try await webservice.request(endpoint: .Characters, responseType: APIResponse<Character>.self)
                characters = retrievedCharacters.results
                errorState = nil
            } catch let error {
                errorState = error
            }
            isLoading = false
        }
    }
}
