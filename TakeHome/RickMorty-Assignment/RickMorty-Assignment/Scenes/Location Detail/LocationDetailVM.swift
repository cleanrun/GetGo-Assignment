//
//  LocationDetailVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import Foundation
import Combine

final class LocationDetailVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: LocationDetailVC?
    
    @Published private(set) var location: Location?
    
    init(vc: LocationDetailVC, location: Location) {
        self.viewController = vc
        self.location = location
    }
    
}
