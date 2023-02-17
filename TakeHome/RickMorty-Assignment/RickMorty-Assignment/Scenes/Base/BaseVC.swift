//
//  BaseVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import UIKit
import Combine

protocol BaseVMProtocol: AnyObject {
    var webservice: Webservice { get }
}

class BaseVC: UIViewController {
    
    var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {}
}

typealias ViewController = BaseVC
typealias ViewModel = BaseVMProtocol
