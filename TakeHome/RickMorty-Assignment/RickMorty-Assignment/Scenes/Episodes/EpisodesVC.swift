//
//  EpisodesVC.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 17/02/23.
//

import UIKit
import Combine

final class EpisodesVC: ViewController {
    private typealias DataSource = UITableViewDiffableDataSource<Int, Episode>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Episode>
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var viewModel: EpisodesVM!
    private var dataSource: DataSource!
    
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
        viewModel.getEpisodes()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseIdentifier)
        
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseIdentifier) as! EpisodeCell
            cell.selectionStyle = .none
            cell.setContents(item)
            return cell
        }
    }
    
    override func setupBindings() {
        viewModel.$episodes.receive(on: DispatchQueue.main).sink { [unowned self] value in
            self.setupSnapshot(value)
        }.store(in: &disposables)
    }
    
    private func setupSnapshot(_ value: [Episode]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(value, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension EpisodesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        EpisodesNavigator.presentEpisodeDetailModal(using: self, for: viewModel.episodes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.episodes.count == indexPath.row + 1 {
            viewModel.getEpisodes()
        }
    }
}
