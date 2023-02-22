//
//  LocationVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 19/02/23.
//

import UIKit

final class LocationVC: BaseVC {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Location>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Location>
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private var viewModel: LocationVM!
    private var dataSource: DataSource!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = LocationVM(vc: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard initializations is not supported")
    }
    
    override func loadView() {
        super.loadView()
        title = "Location"
        
        navigationItem.searchController = searchController
        
        addSubviewAndConstraints(view: tableView, constraints: [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getLocations()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseIdentifier)
        
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier) as! LocationCell
            cell.selectionStyle = .none
            cell.setContents(item)
            return cell
        }
    }
    
    override func setupBindings() {
        viewModel.$locations.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.setupSnapshot(value)
        }.store(in: &disposables)
        
        viewModel.$errorState.receive(on: DispatchQueue.main).sink { value in
            print("is error nil \(value == nil)")
        }.store(in: &disposables)
        
        viewModel.$searchQuery.debounce(for: 1, scheduler: DispatchQueue.main).sink { [unowned self] _ in
            self.viewModel.filterLocationsByQuery()
        }.store(in: &disposables)
    }
    
    private func setupSnapshot(_ value: [Location]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(value, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension LocationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocationNavigator.presentLocationDetailModal(using: self, for: viewModel.locations[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.locations.count == indexPath.row + 2 && viewModel.searchQuery == nil {
            viewModel.getLocations()
        }
    }
}

extension LocationVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setSearchQuery(searchText)
    }
}
