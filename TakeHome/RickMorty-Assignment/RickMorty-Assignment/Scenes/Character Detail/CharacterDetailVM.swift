//
//  CharacterDetailVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import Foundation
import Combine

final class CharacterDetailVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: CharacterDetailVC?
    
    @Published private(set) var character: Character
    
    init(vc: CharacterDetailVC, character: Character) {
        self.viewController = vc
        self.character = character
    }
    
}

