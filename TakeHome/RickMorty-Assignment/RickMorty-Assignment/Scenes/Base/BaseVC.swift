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
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {}
    
    func addSubviewAndConstraints(view: UIView, constraints: [NSLayoutConstraint]) {
        self.view.addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}

typealias ViewController = BaseVC
typealias ViewModel = ObservableObject & BaseVMProtocol
