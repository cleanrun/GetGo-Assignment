//
//  EpisodeCell.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import UIKit

final class EpisodeCell: UITableViewCell, ReusableView {
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private var episodeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var episodeInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private var episodeSeasonAndEpisodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var episodeAirDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 2
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(containerStackView)
        containerStackView.addArrangedSubviews(episodeNameLabel, episodeInfoStackView)
        episodeInfoStackView.addArrangedSubviews(episodeSeasonAndEpisodeLabel, episodeAirDateLabel)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 14),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14),
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -17),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeNameLabel.text = nil
        episodeSeasonAndEpisodeLabel.text = nil
        episodeAirDateLabel.text = nil
    }
    
    func setContents(_ episode: Episode) {
        episodeNameLabel.text = episode.name
        var season = "\(episode.episode[1])\(episode.episode[2])"
        var episodeNumber = "\(episode.episode[4])\(episode.episode[5])"
        
        if season.first == "0" {
            season.removeFirst()
        }
        
        if episodeNumber.first == "0" {
            episodeNumber.removeFirst()
        }
                
        episodeSeasonAndEpisodeLabel.text = "season: \(season)\nepisode: \(episodeNumber)"
        episodeAirDateLabel.text = "Air Date:\n\(episode.airDate)"
    }
}
