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

    lazy var sections: [StaticSection] = [
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Name", detail: UserDefaults.standard.string(forKey: "name"), click: didTapChangeName),
            StaticTableViewCellConfig(title: "Email", detail: UserDefaults.standard.string(forKey: "email"), click: didTapChangeEmail),
            StaticTableViewCellConfig(title: "Programme", detail: UserDefaults.standard.string(forKey: "programme"), click: didTapChangeProgramme),
            StaticTableViewCellConfig(title: "Change PIN", detail: "‌\u{2022}‌\u{2022}‌\u{2022}‌\u{2022}", click: didTapChangePin),
        ]),
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Face-ID", type: .switch, switchAction: didTapFaceId),
            StaticTableViewCellConfig(title: "Swipe confirmation", type: .switch, switchAction: didTapSwipeConfirmation),
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
    private func didTapChangeProgramme() { navigateToUpdateUser(type: .programme) }

    private func didTapPrivacy() {
        let vc = PrivacyViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToUpdateUser(type: UserFieldType) {
        let vc = UpdateUserViewController(type: type)
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
        tableView.backgroundColor = Color.background
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }
}
