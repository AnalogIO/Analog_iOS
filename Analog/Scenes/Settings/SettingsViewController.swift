//
//  SettingsViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class SettingsViewController: UIViewController {

    let tableView = Views.tableView()

    let cellConfigs: [[StaticTableViewCellConfig]] = [
        [
            StaticTableViewCellConfig(title: "Name"),
            StaticTableViewCellConfig(title: "Email"),
            StaticTableViewCellConfig(title: "Programme"),
            StaticTableViewCellConfig(title: "Change PIN"),
        ],
        [
            StaticTableViewCellConfig(title: "Face-ID"),
            StaticTableViewCellConfig(title: "Swipe confirmation"),
        ],
        [
            StaticTableViewCellConfig(title: "Privacy"),
        ]
    ]

    let viewModel: SettingsViewModel

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    private func defineLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {}
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        default:
            break
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellConfigs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigs[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StaticTableViewCell.reuseIdentifier, for: indexPath) as! StaticTableViewCell
        let config = cellConfigs[indexPath.section][indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

extension SettingsViewController: SettingsViewModelDelegate {}

private enum Views {
    static func tableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Color.background
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }
}
