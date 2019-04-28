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
    let idLabel = Views.idLabel()
    let profileImage = Views.profileImage()
    let scrollView = Views.scrollView()

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
                StaticTableViewCellConfig(title: "Face-ID", type: .switch, switchAction: didTapFaceId),
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
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        scrollView.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
        ])

        scrollView.addSubview(idLabel)
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            idLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20),
        ])

        scrollView.addSubview(rankView)
        NSLayoutConstraint.activate([
            rankView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rankView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rankView.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 20),
            rankView.heightAnchor.constraint(equalToConstant: 100),
        ])

        scrollView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: rankView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400),
        ])
    }

    private func updateView() {
        guard let user = user else { return }
        tableView.reloadData()
        rankView.user = user
        idLabel.text = "ID: \(user.id)"
    }

    private func didTapFaceId(sender: UISwitch) {
        print("Face-ID: \(sender.isOn)")
    }

    private func didTapSwipeConfirmation(sender: UISwitch) {
        print("Swipe: \(sender.isOn)")
    }

    private func didTapPrivacyPolicy() {
        guard let url = URL(string: "http://privacy.analogio.dk/privacypolicycafeanalog.pdf") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    private func setupTargets() {}

    private func didTapChangeName() { navigateToUpdateUser(type: .name) }
    private func didTapChangeEmail() { navigateToUpdateUser(type: .email) }
    private func didTapChangePin() { navigateToUpdateUser(type: .pin) }

    @objc private func didTapLogout(sender: UIBarButtonItem) {
        navigateToLogin()
    }

    private func navigateToUpdateUser(type: UpdateType) {
        let vc = UpdateUserViewController(viewModel: UpdateUserViewModel(),type: type)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToLogin() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        present(vc, animated: true, completion: nil)
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
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }

    static func idLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.espresso
        label.textAlignment = .center
        label.font = Font.font(size: 38)
        return label
    }

    static func rankView() -> RankView {
        let view = RankView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadow()
        return view
    }

    static func profileImage() -> UIImageView {
        let view = UIImageView(image: #imageLiteral(resourceName: "profile_icon"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }

    static func scrollView() -> UIScrollView {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
