//
//  CharacterNavigator.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 22/02/23.
//

import Foundation

final class CharacterNavigator {
    static func routeToCharacterDetail(using vc: BaseVC, for character: Character) {
        let detailVc = CharacterDetailVC(character: character)
        vc.navigationController?.pushViewController(detailVc, animated: true)
    }
}
