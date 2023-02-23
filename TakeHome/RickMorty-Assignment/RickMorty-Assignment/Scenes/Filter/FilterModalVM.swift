//
//  FilterModalVM.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 23/02/23.
//

import Foundation
import Combine

let kPostFilterNotification = NSNotification.Name("kPostFilterNotification")

final class FilterModalVM: ViewModel {
    @Dependency(\.webservice) var webservice: Webservice
    private weak var viewController: FilterModalVC?
    
    @Published private(set) var selectedStatus: Filter? = nil
    @Published private(set) var selectedSpecies: Filter? = nil
    @Published private(set) var selectedGender: Filter? = nil
    
    init(vc: FilterModalVC) {
        self.viewController = vc
    }
    
    func setSelectedStatus(_ status: Filter) {
        selectedStatus = status
    }
    
    func setSelectedSpecies(_ species: Filter) {
        selectedSpecies = species
    }
    
    func setSelectedGender(_ gender: Filter) {
        selectedGender = gender
    }
    
    func postFilterNotification() {
        guard (selectedStatus != nil || selectedSpecies != nil || selectedGender != nil) else { return }
        
        var filters: [Filter] = []
        if selectedStatus != nil { filters.append(selectedStatus!) }
        if selectedSpecies != nil { filters.append(selectedSpecies!) }
        if selectedGender != nil { filters.append(selectedGender!) }
        
        NotificationCenter.default.post(Notification(name: kPostFilterNotification, object: filters))
    }
    
    func postResetFilterNotification() {
        NotificationCenter.default.post(Notification(name: kPostFilterNotification, object: nil))
    }
}
