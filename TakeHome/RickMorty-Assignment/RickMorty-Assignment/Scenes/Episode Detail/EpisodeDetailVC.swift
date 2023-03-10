//
//  EpisodeDetailVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 21/02/23.
//

import UIKit

class EpisodeDetailVC: BaseVC {

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
    
    private var episodeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    private var episodeCreatedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private var episodeAirDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var episodeSeasonAndEpisodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private var episodeCharactersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private var viewModel: EpisodeDetailVM!

    init(episode: Episode) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = EpisodeDetailVM(vc: self, episode: episode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        title = viewModel.episode?.name
        
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
        
        containerStackView.addArrangedSubviews(UIView(), episodeNameLabel, episodeCreatedLabel, episodeAirDateLabel, episodeSeasonAndEpisodeLabel, episodeCharactersLabel)
    }
    
    private func setupContents(_ episode: Episode) {
        var season = "\(episode.episode[1])\(episode.episode[2])"
        var episodeNumber = "\(episode.episode[4])\(episode.episode[5])"
        
        if season.first == "0" {
            season.removeFirst()
        }
        
        if episodeNumber.first == "0" {
            episodeNumber.removeFirst()
        }

        episodeNameLabel.text = episode.name
        
        let createdAttributedString = NSMutableAttributedString(string: "Created\n",
                                                                attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        createdAttributedString.append(NSAttributedString(string: episode.created.getDateWithFormat(using: .created),
                                                          attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular)]))
        episodeCreatedLabel.attributedText = createdAttributedString
        
        let airDateAttributedString = NSMutableAttributedString(string: "Air Date: ",
                                                                attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        airDateAttributedString.append(NSAttributedString(string: episode.airDate.getDateWithFormat(using: .airDate),
                                                          attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        episodeAirDateLabel.attributedText = airDateAttributedString
        
        episodeSeasonAndEpisodeLabel.text = "Season: \(season)\nEpisode: \(episodeNumber)"
        
        let charactersString = episode.characters.joined(separator: "\n")
        let charactersAttributedString = NSMutableAttributedString(string: "Characters:\n",
                                                                  attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
        charactersAttributedString.append(NSAttributedString(string: charactersString,
                                                            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        
        
        episodeCharactersLabel.attributedText = charactersAttributedString
    }
    
    override func setupBindings() {
        viewModel.$episode.receive(on: DispatchQueue.main).sink { [unowned self] value in
            if let value {
                self.setupContents(value)
            }
        }.store(in: &disposables)
    }

}
