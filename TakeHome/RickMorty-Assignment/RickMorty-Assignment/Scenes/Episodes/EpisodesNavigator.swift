//
//  EpisodesNavigator.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import UIKit

final class EpisodesNavigator {
    static func presentEpisodeDetailModal(using vc: BaseVC, for episode: Episode) {
        let modal = EpisodeDetailVC(episode: episode)
        let navController = UINavigationController(rootViewController: modal)
        vc.present(navController, animated: true)
    }
}
