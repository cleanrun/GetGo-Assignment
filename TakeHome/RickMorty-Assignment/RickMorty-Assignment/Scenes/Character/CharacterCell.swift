//
//  CharacterCell.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import UIKit

final class CharacterCell: UICollectionViewCell, ReusableView {
    private var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var characterInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var characterInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private var characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var characterTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var representedID: UUID?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        contentView.addSubviews(characterImageView, characterInfoView)
        characterInfoView.addSubview(characterInfoStackView)
        characterInfoStackView.addArrangedSubviews(characterNameLabel, characterTypeLabel)

        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 177),
            
            characterInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterInfoView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor),
            characterInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            characterInfoStackView.leadingAnchor.constraint(equalTo: characterInfoView.leadingAnchor),
            characterInfoStackView.trailingAnchor.constraint(equalTo: characterInfoView.trailingAnchor),
            characterInfoStackView.centerYAnchor.constraint(equalTo: characterInfoView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        characterNameLabel.text = nil
        characterTypeLabel.text = nil
    }
    
    func setContents(_ character: Character) {
        representedID = character.id
        characterNameLabel.text = character.name
        characterTypeLabel.text = character.species
        characterInfoView.backgroundColor = UIColor(hex: character.species == "Human" ? "#EDEDED" : "#D3FF22")
    }
    
    func updateImage(_ image: UIImage?) {
        characterImageView.image = image
    }
    
}
