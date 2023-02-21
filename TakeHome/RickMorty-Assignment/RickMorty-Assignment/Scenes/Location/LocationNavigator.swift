//
//  LocationNavigator.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import UIKit

final class LocationNavigator {
    static func presentLocationDetailModal(using vc: BaseVC, for location: Location) {
        let modal = LocationDetailVC(location: location)
        let navController = UINavigationController(rootViewController: modal)
        vc.present(navController, animated: true)
    }
}
