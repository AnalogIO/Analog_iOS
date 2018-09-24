//
//  MoreViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views

class MoreViewController: UIViewController {

    let tableView = Views.tableView()

    let cellConfigs: [[MoreTableViewCellConfig]] = [
        [
            MoreTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_purchases"), title: "Purchases"),
            MoreTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_settings"), title: "Settings"),
            MoreTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_help"), title: "Help (FAQ)"),
            MoreTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_shop"), title: "Shop"),
            MoreTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_voucher"), title: "Redeem Voucher")
        ],
        [
            MoreTableViewCellConfig(title: "Log out", type: .escape)
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        tableView.dataSource = self
        tableView.delegate = self
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

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellConfigs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigs[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoreTableViewCell.reuseIdentifier, for: indexPath) as! MoreTableViewCell
        let config = cellConfigs[indexPath.section][indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

private enum Views {
    static func tableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MoreTableViewCell.self, forCellReuseIdentifier: MoreTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Color.background
        return tableView
    }
}
