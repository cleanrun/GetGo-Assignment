//
//  FilterModalVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 23/02/23.
//

import UIKit

final class FilterModalVC: BaseVC {
    private typealias DataSource = UICollectionViewDiffableDataSource<FilterType, Filter>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FilterType, Filter>
    
    private var dragIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#D9D9D9")
        view.layer.cornerRadius = 2
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.text = "Filter"
        return label
    }()
    
    private var resetFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.link, for: .normal)
        button.setTitle("Reset", for: .normal)
        return button
    }()
    
    private var filterCollectionView: UICollectionView = {
        var layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var applyFilterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(hex: "#007AFF")
        button.setTitle("Apply", for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private var viewModel: FilterModalVM!
    private var dataSource: DataSource!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = FilterModalVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        view.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        view.addSubviews(dragIndicatorView, titleLabel, resetFilterButton, applyFilterButton, filterCollectionView)
        NSLayoutConstraint.activate([
            dragIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: 56),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 4),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
            titleLabel.topAnchor.constraint(equalTo: dragIndicatorView.bottomAnchor, constant: 30),
            
            resetFilterButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            resetFilterButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            applyFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            applyFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            applyFilterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -11),
            applyFilterButton.heightAnchor.constraint(equalToConstant: 50),
            
            filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 23),
            filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
            filterCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            filterCollectionView.bottomAnchor.constraint(equalTo: applyFilterButton.topAnchor, constant: -16),
        ])
        
        setupCollectionView()
        
        applyFilterButton.addTarget(self, action: #selector(applyAction), for: .touchUpInside)
        resetFilterButton.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
    }
    
    @objc private func applyAction() {
        dismiss(animated: true) { [weak self] in
            self?.viewModel.postFilterNotification()
        }
    }
    
    @objc private func resetAction() {
        dismiss(animated: true) { [weak self] in
            self?.viewModel.postResetFilterNotification()
        }
    }
    
    private func setupCollectionView() {
        filterCollectionView.delegate = self
        filterCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
        filterCollectionView.register(FilterHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterHeaderView.reuseIdentifier)
        
        dataSource = DataSource(collectionView: filterCollectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as! FilterCell
            cell.setContents(item.title)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterHeaderView.reuseIdentifier, for: indexPath) as! FilterHeaderView
            let title: String = {
                switch indexPath.section {
                case 0:
                    return "Status"
                case 1:
                    return "Species"
                default:
                    return "Gender"
                }
            }()
            header.setContents(title)
            return header
        }
        
        setupSnapshot()
    }
    
    private func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.status, .species, .gender])
        snapshot.appendItems(Filter.statusFilters(), toSection: .status)
        snapshot.appendItems(Filter.speciesFilters(), toSection: .species)
        snapshot.appendItems(Filter.genderFilters(), toSection: .gender)
        dataSource.apply(snapshot)
    }
    
}

extension FilterModalVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        collectionView.deselectItemsInSection(section: section, animated: true)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        
        switch section {
        case 0:
            viewModel.setSelectedStatus(Filter.statusFilters()[indexPath.row])
        case 1:
            viewModel.setSelectedSpecies(Filter.speciesFilters()[indexPath.row])
        default:
            viewModel.setSelectedGender(Filter.genderFilters()[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 35
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
        let width: CGFloat = {
            switch indexPath.section {
            case 0:
                return Filter.statusFilters()[indexPath.row].title.size(withAttributes: attributes).width + 50
            case 1:
                return Filter.speciesFilters()[indexPath.row].title.size(withAttributes: attributes).width + 50
            default:
                return Filter.genderFilters()[indexPath.row].title.size(withAttributes: attributes).width + 50
            }
        }()
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 40)
    }

}
