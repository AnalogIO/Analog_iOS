//
//  HomeTabBarViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import ShiftPlanningAPI
import ClipCardAPI
import Entities

protocol HomeTabBarViewControllerDelegate {}

class HomeTabBarViewController: UITabBarController {

    var timer: Timer? = nil

    let statusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        return button
    }()

    let clipcard = ClipCardAPI(token: KeyChainService.shared.get(key: .token))
    let shiftplanning = ShiftPlanningAPI()
    lazy var provider = Provider(clipcard: clipcard, shiftplanning: shiftplanning)

    private let tabBarConfigs: [TabBarConfig] = [
        TabBarConfig(title: "Tickets", icon: #imageLiteral(resourceName: "Tickets")),
        TabBarConfig(title: "Receipts", icon: #imageLiteral(resourceName: "Receipts")),
        TabBarConfig(title: "Profile", icon: #imageLiteral(resourceName: "Profile")),
        TabBarConfig(title: "Leaderboard", icon: #imageLiteral(resourceName: "leaderboard_icon")),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureTabBar()
        self.fetchCafeStatus()

        clipcard.delegate = self

        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(fetchCafeStatus), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }

    @objc private func applicationDidBecomeActive() {
        fetchCafeStatus()
    }

    func configureNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    func configureTabBar() {
        tabBar.tintColor = Color.espresso
        tabBar.barTintColor = Color.milk
        let controllers: [UINavigationController] = [
            UINavigationController(rootViewController: TicketsViewController(viewModel: TicketsViewModel(provider: provider))),
            UINavigationController(rootViewController: ReceiptsViewController(viewModel: ReceiptsViewModel(provider: provider))),
            UINavigationController(rootViewController: ProfileViewController(viewModel: ProfileViewModel(provider: provider))),
            UINavigationController(rootViewController: LeaderboardViewController(viewModel: LeaderboardViewModel(provider: provider))),
        ]
        controllers.enumerated().forEach { (index, vc) in
            let config = tabBarConfigs[index]
            vc.tabBarItem = UITabBarItem(title: config.title, image: config.icon, tag: index)
            vc.topViewController?.navigationItem.leftBarButtonItem = statusButton
        }
        self.viewControllers = controllers
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func navigateToLogin() {
        dismiss(animated: true, completion: nil)
    }

    @objc func fetchCafeStatus() {
        Cafe.isOpen().response(using: provider.shiftplanning, method: .get) { response in
            switch response {
            case .success(let value):
                if value.open {
                    self.statusButton.title = "ÅPEN"
                    self.statusButton.tintColor = Color.green
                } else {
                    self.statusButton.title = "CLØSED"
                    self.statusButton.tintColor = Color.red
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeTabBarViewController: ClipCardAPIDelegate {
    func invalidToken() {
        navigateToLogin()
    }
}

private struct TabBarConfig {
    let title: String
    let icon: UIImage
}
