//
//  LeaderboardViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class LeaderboardViewController: UIViewController {

    let tableView = Views.tableView()

    var cellConfigs: [LeaderboardTableViewCellConfig] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var indicator = ActivityIndication(container: view)

    let viewModel: LeaderboardViewModel

    init(viewModel: LeaderboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leaderboard"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func defineLayout() {}

    private func setupTargets() {}
}

extension LeaderboardViewController: UITableViewDelegate {}

extension LeaderboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardTableViewCell.reuseIdentifier, for: indexPath) as! LeaderboardTableViewCell
        let config = cellConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension LeaderboardViewController: LeaderboardViewModelDelegate {
    func didSetFetchLeaderboardState(state: State<[LeaderboardTableViewCellConfig]>) {
        switch state {
        case .loaded(let configs):
            indicator.stop()
            self.cellConfigs = configs
        case .loading:
            indicator.start()
        case .error(let error):
            indicator.stop()
            print(error.localizedDescription)
        default:
            break
        }
    }
}

private enum Views {
    static func tableView() -> UITableView {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tableFooterView = UIView()
        view.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: LeaderboardTableViewCell.reuseIdentifier)
        return view
    }
}
