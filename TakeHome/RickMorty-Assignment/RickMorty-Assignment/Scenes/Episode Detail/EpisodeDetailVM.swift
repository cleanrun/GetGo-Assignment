//
//  EpisodeDetailVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import Foundation
import Combine

final class EpisodeDetailVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: EpisodeDetailVC?
    
    @Published private(set) var episode: Episode?
    
    init(vc: EpisodeDetailVC, episode: Episode) {
        self.viewController = vc
        self.episode = episode
    }
}
