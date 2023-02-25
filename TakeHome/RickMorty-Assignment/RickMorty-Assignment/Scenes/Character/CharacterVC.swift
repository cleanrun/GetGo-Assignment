//
//  CharacterVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import UIKit

final class CharacterVC: BaseVC {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Character>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Character>
    
    private var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private var viewModel: CharacterVM!
    private var dataSource: DataSource!
    private let imageDownloader = AsyncImageDownloader()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = CharacterVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }

    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Character"
        
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(filterAction))
        
        addSubviewAndConstraints(view: collectionView, constraints: [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getCharacters()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseIdentifier)
        
        dataSource = DataSource(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as! CharacterCell
            cell.setContents(item)
            
            if let downloadedImage = self.imageDownloader.downloadedImage(for: item.id) {
                cell.updateImage(downloadedImage)
                return cell
            }
            
            cell.updateImage(nil)
            self.imageDownloader.downloadAsync(item.id, imageURLString: item.image) { image in
                DispatchQueue.main.async {
                    guard cell.representedID == item.id else { return }
                    cell.updateImage(image)
                }
            }
            
            return cell
        }
    }

    override func setupBindings() {
        viewModel.$characters.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.setupSnapshot(value)
        }.store(in: &disposables)
        
        viewModel.$searchQuery.debounce(for: 1, scheduler: DispatchQueue.main).sink { [unowned self] _ in
            self.viewModel.filterCharactersByQuery()
        }.store(in: &disposables)
    }
    
    private func setupSnapshot(_ value: [Character]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(value, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func deleteAllItemsFromSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc private func filterAction() {
        CharacterNavigator.presentFilterModal(using: self)
    }
}

extension CharacterVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CharacterNavigator.routeToCharacterDetail(using: self, for: viewModel.characters[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat =  (collectionView.frame.width / 2) - 20
        let height: CGFloat = 234
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.characters.count == indexPath.row + 1 && viewModel.searchQuery == nil {
            viewModel.getCharacters()
        }
    }
}

extension CharacterVC: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = viewModel.characters[indexPath.row]
            imageDownloader.downloadAsync(item.id, imageURLString: item.image)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let item = viewModel.characters[indexPath.row]
            imageDownloader.cancelDownload(item.id)
        }
    }
}

extension CharacterVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchQuery(searchText)
    }
}
