//
//  EpisodesVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import UIKit
import Combine

final class EpisodesVC: ViewController {
    private var viewModel: EpisodesVM!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = EpisodesVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        title = "Episode"
        view.backgroundColor = .systemBackground
    }
    
}
