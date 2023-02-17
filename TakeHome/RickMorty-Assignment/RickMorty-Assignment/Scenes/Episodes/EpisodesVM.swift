//
//  EpisodesVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import Foundation
import Combine

final class EpisodesVM: ObservableObject, ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: EpisodesVC?
    
    init(vc: EpisodesVC) {
        self.viewController = vc
    }
}

