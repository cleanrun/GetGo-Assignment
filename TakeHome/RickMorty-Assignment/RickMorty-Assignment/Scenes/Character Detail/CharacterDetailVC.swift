//
//  CharacterDetailVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import UIKit

final class CharacterDetailVC: BaseVC {
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
        stackView.spacing = 19
        return stackView
    }()
    
    private var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 21
        return stackView
    }()
    
    private var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private var midStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 21
        return stackView
    }()
    
    private var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private var characterInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var characterCreatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var characterOriginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var characterLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var characterEpisodesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var viewModel: CharacterDetailVM!

    init(character: Character) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = CharacterDetailVM(vc: self, character: character)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        navigationItem.largeTitleDisplayMode = .never
        title = viewModel.character.name
        
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(containerStackView)
        containerStackView.addArrangedSubviews(UIView(), topStackView, midStackView, characterEpisodesLabel, UIView())
        topStackView.addArrangedSubviews(characterImageView, infoStackView)
        infoStackView.addArrangedSubviews(characterInfoLabel, characterCreatedLabel)
        midStackView.addArrangedSubviews(characterOriginLabel, characterLocationLabel)
        
        NSLayoutConstraint.activate([
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerStackView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerScrollView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: containerScrollView.widthAnchor, multiplier: 1),
            
        ])
    }
    
    override func setupBindings() {
        viewModel.$character.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.setupContents(value)
        }.store(in: &disposables)
    }

    private func setupContents(_ character: Character) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let url = URL(string: character.image) {
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.characterImageView.image = image
                    }
                }
            }
        }
        
        let statusImageAttachment = NSTextAttachment()
        statusImageAttachment.image = UIImage(named: character.status.icon)
        statusImageAttachment.bounds = CGRect(x: 0, y: -4.0, width: 25, height: 25)
        let statusImageAttachmentString = NSAttributedString(attachment: statusImageAttachment)
        
        let genderImageAttachment = NSTextAttachment()
        genderImageAttachment.image = UIImage(named: character.gender.icon)
        genderImageAttachment.bounds = CGRect(x: 0, y: -4.0, width: 25, height: 25)
        let genderImageAttachmentString = NSAttributedString(attachment: genderImageAttachment)
        
        let infoAttributedString = NSMutableAttributedString(string: "\(character.name)\n\n",
                                                             attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        infoAttributedString.append(NSAttributedString(string: "Status: \(character.status.rawValue) ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        infoAttributedString.append(statusImageAttachmentString)
        infoAttributedString.append(NSAttributedString(string: "\n\nGender: \(character.gender.rawValue) ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        infoAttributedString.append(genderImageAttachmentString)
        infoAttributedString.append(NSAttributedString(string: "\n\nSpecies: \(character.species) ",
                                                       attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        characterInfoLabel.attributedText = infoAttributedString
        
        let createdAttributedString = NSMutableAttributedString(string: "Created\n",
                                                                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        createdAttributedString.append(NSAttributedString(string: character.created,
                                                          attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)]))
        characterCreatedLabel.attributedText = createdAttributedString
        
        let originAttributedString = NSMutableAttributedString(string: "Origin\n",
                                                               attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        originAttributedString.append(NSAttributedString(string: character.origin.name,
                                                         attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        characterOriginLabel.attributedText = originAttributedString
        
        let locationAttributedString = NSMutableAttributedString(string: "Location\n",
                                                               attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        locationAttributedString.append(NSAttributedString(string: character.location.name,
                                                         attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        characterLocationLabel.attributedText = locationAttributedString
        
        let episodesString = character.episode.joined(separator: "\n")
        let episodesAttributedString = NSMutableAttributedString(string: "Episode\n",
                                                               attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        episodesAttributedString.append(NSAttributedString(string: episodesString,
                                                         attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        characterEpisodesLabel.attributedText = episodesAttributedString
    }
    
}
