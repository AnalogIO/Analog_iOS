//
//  ProfileViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class ProfileViewController: UIViewController {

    let tableView = Views.tableView()
    let rankView = Views.rankView()
    let numberLabel = Views.numberLabel()
    let idLabel = Views.idLabel()
    let stackView = Views.stackView()

    var user: User? = nil {
        didSet {
            updateView()
        }
    }

    var sections: [StaticSection] {
        return [
            StaticSection(cellConfigs: [
                StaticTableViewCellConfig(title: "Name", detail: user?.name, click: didTapChangeName),
                StaticTableViewCellConfig(title: "Email", detail: user?.email, click: didTapChangeEmail),
                StaticTableViewCellConfig(title: "Change PIN", detail: "‌\u{2022}‌\u{2022}‌\u{2022}‌\u{2022}", click: didTapChangePin),
            ]),
            StaticSection(cellConfigs: [
                StaticTableViewCellConfig(title: "Face/Touch ID", type: .switch, switchAction: didTapFaceId),
                StaticTableViewCellConfig(title: "Privacy policy", click: didTapPrivacyPolicy),
            ]),
        ]
    }

    let viewModel: ProfileViewModel

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: ProfileViewModel) {
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
        title = "Profile"
        view.backgroundColor = Color.grey

        defineLayout()
        setupTargets()

        let barButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(didTapLogout))
        navigationItem.rightBarButtonItem = barButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    private func defineLayout() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
        ])

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        stackView.addArrangedSubview(idLabel)
        stackView.addArrangedSubview(numberLabel)
        stackView.addArrangedSubview(.spacing(10))
        stackView.addArrangedSubview(rankView)

        NSLayoutConstraint.activate([
            rankView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func updateView() {
        guard let user = user else { return }
        tableView.reloadData()
        rankView.user = user
        numberLabel.text = "\(user.id)"
    }

    private func didTapFaceId(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultKey.isFaceTouchEnabled.rawValue)
    }

    private func didTapPrivacyPolicy() {
        guard let url = URL(string: "http://privacy.analogio.dk/privacypolicycafeanalog.pdf") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func setupTargets() {}

    private func didTapChangeName() { navigateToUpdateUser(type: .name, initialValue: user?.name) }
    private func didTapChangeEmail() { navigateToUpdateUser(type: .email, initialValue: user?.email) }
    private func didTapChangePin() { navigateToUpdateUser(type: .password) }

    @objc private func didTapLogout(sender: UIBarButtonItem) {
        navigateToLogin()
    }

    private func navigateToUpdateUser(type: UpdateType, initialValue: String? = nil) {
        let vc = UpdateUserViewController(viewModel: UpdateUserViewModel(), type: type, initialValue: initialValue)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToLogin() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let config = sections[indexPath.section].cellConfigs[indexPath.row]
        config.click?()
    }
}

extension ProfileViewController: UITableViewDataSource {
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

extension ProfileViewController: ProfileViewModelDelegate {
    func didSetFetchUserState(state: State<User>) {
        switch state {
        case .loaded(let user):
            indicator.stop()
            self.user = user
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
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.reuseIdentifier)
        tableView.isScrollEnabled = true
        tableView.bounces = false
        return tableView
    }

    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func idLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.espresso
        label.textAlignment = .center
        label.font = Font.font(size: 15)
        label.text = "Your ID:"
        return label
    }

    static func numberLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.espresso
        label.textAlignment = .center
        label.font = Font.boldFont(size: 55)
        label.text = "-"
        return label
    }

    static func rankView() -> RankView {
        let view = RankView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
