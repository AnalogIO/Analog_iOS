//
//  SettingsViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class SettingsViewController: UIViewController {

    let tableView = Views.tableView()

    lazy var sections: [StaticSection] = [
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Name", detail: UserDefaults.standard.string(forKey: UpdateType.name.rawValue), click: didTapChangeName),
            StaticTableViewCellConfig(title: "Email", detail: UserDefaults.standard.string(forKey: UpdateType.email.rawValue), click: didTapChangeEmail),
            StaticTableViewCellConfig(title: "Change PIN", detail: "‌\u{2022}‌\u{2022}‌\u{2022}‌\u{2022}", click: didTapChangePin),
        ]),
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Face-ID", type: .switch, switchAction: didTapFaceId),
        ]),
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Privacy", click: didTapPrivacy),
        ]),
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
        view.backgroundColor = UIColor.groupTableViewBackground

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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

    private func didTapFaceId(sender: UISwitch) {
        print("Face-ID: \(sender.isOn)")
    }

    private func didTapSwipeConfirmation(sender: UISwitch) {
        print("Swipe: \(sender.isOn)")
    }

    private func setupTargets() {}

    private func didTapChangeName() { navigateToUpdateUser(type: .name) }
    private func didTapChangeEmail() { navigateToUpdateUser(type: .email) }
    private func didTapChangePin() { navigateToUpdateUser(type: .pin) }

    private func didTapPrivacy() {
        let vc = PrivacyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToUpdateUser(type: UpdateType) {
        //let vc = UpdateUserViewController(viewModel: UpdateUserViewModel(), type: type)
        let vc = UpdateUserViewController(viewModel: UpdateUserViewModel(),type: type)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let config = sections[indexPath.section].cellConfigs[indexPath.row]
        config.click?()
    }
}

extension SettingsViewController: UITableViewDataSource {
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

extension SettingsViewController: SettingsViewModelDelegate {}

private enum Views {
    static func tableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }
}
