//
//  MoreViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    let tableView = Views.tableView()

    lazy var sections: [StaticSection] = [
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_purchases"), title: "Purchases", click: navigateToPurchases),
            StaticTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_settings"), title: "Settings", click: navigateToSettings),
            StaticTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_help"), title: "Help (FAQ)", click: navigateToHelp),
            StaticTableViewCellConfig(icon: UIImage(imageLiteralResourceName: "more_voucher"), title: "Redeem Voucher", click: navigateToVoucher)
        ]),
        StaticSection(cellConfigs: [
            StaticTableViewCellConfig(title: "Log out", type: .escape, click: navigateToLogin)
        ]),
    ]

    let viewModel: MoreViewModel

    init(viewModel: MoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        setupNavbarLogo()

        defineLayout()
        setupTargets()

        viewModel.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
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

    private func navigateToPurchases() {
        let vc = PurchasesViewController(viewModel: PurchasesViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToSettings() {
        let vc = SettingsViewController(viewModel: SettingsViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToHelp() {
        let vc = HelpViewController(viewModel: HelpViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToShop() {
        let vc = ShopViewController(viewModel: ShopViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToVoucher() {
        let vc = VoucherViewController(viewModel: VoucherViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToLogin() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        present(vc, animated: true, completion: nil)
    }
}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let config = sections[indexPath.section].cellConfigs[indexPath.row]
        config.click?()
    }
}

extension MoreViewController: UITableViewDataSource {
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

extension MoreViewController: MoreViewModelDelegate {}

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
