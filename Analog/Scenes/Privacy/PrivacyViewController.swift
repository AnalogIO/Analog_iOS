//
//  PrivacyViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 01/10/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    let tableView = Views.tableView()

    lazy var sections: [StaticSection] = [
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Anonymous", type: .switch, switchAction: didTapAnonymousSwitch),
        ]),
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Privacy policy", click: didTapPrivacyPolicy),
        ]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy"
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {}

    private func didTapPrivacyPolicy() {
        guard let url = URL(string: "http://privacy.analogio.dk/privacypolicycafeanalog.pdf") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func didTapAnonymousSwitch(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "anonymous")
    }
}

extension PrivacyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let config = sections[indexPath.section].cellConfigs[indexPath.row]
        config.click?()
    }
}

extension PrivacyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellConfigs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StaticTableViewCell.reuseIdentifier, for: indexPath) as! StaticTableViewCell
        let config = sections[indexPath.section].cellConfigs[indexPath.row]
        cell.configure(config: config)
        return cell
    }
}

private enum Views {
    static func tableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Color.background
        return tableView
    }
}
