//
//  LocationDetailVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import UIKit

final class LocationDetailVC: BaseVC {
    private var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private var locationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private var locationCreatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private var locationTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var locationDimensionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var locationResidentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var viewModel: LocationDetailVM!

    init(location: Location) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = LocationDetailVM(vc: self, location: location)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        title = viewModel.location?.name
        
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        addSubviewAndConstraints(view: containerScrollView, constraints: [
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        containerScrollView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor, multiplier: 1)
        ])
        
        containerStackView.addArrangedSubviews(UIView(), locationNameLabel, locationCreatedLabel, locationTypeLabel, locationDimensionLabel, locationResidentsLabel)
    }
    
    private func setupContents(_ location: Location) {
        locationNameLabel.text = location.name
        
        let createdAttributedString = NSMutableAttributedString(string: "Created\n",
                                                                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        createdAttributedString.append(NSAttributedString(string: location.created.getDateWithFormat(using: .created),
                                                          attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)]))
        locationCreatedLabel.attributedText = createdAttributedString
        
        locationTypeLabel.text = "Type: \(location.type)"
        locationDimensionLabel.text = "Dimension:\n\(location.dimension)"
        
        let residentsString = location.residents.joined(separator: "\n")
        let residentsAttributedString = NSMutableAttributedString(string: "Residents:\n",
                                                                  attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        residentsAttributedString.append(NSAttributedString(string: residentsString,
                                                            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        locationResidentsLabel.attributedText = residentsAttributedString
    }
    
    override func setupBindings() {
        viewModel.$location.receive(on: DispatchQueue.main).sink { [unowned self] value in
            if let value {
                self.setupContents(value)
            }
        }.store(in: &disposables)
    }

}
