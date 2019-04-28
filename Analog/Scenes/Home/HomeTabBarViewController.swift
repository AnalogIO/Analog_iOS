//
//  HomeTabBarViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

protocol HomeTabBarViewControllerDelegate {}

class HomeTabBarViewController: UITabBarController {

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    func configureNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    func configureTabBar() {
        tabBar.tintColor = Color.espresso
        tabBar.barTintColor = Color.milk
        let controllers: [UIViewController] = [
            UINavigationController(rootViewController: TicketsViewController(viewModel: TicketsViewModel())),
            UINavigationController(rootViewController: ReceiptsViewController(viewModel: ReceiptsViewModel())),
            UINavigationController(rootViewController: ProfileViewController(viewModel: ProfileViewModel())),
            UINavigationController(rootViewController: LeaderboardViewController(viewModel: LeaderboardViewModel())),
        ]
        controllers.enumerated().forEach { (index, vc) in
            let config = tabBarConfigs[index]
            vc.tabBarItem = UITabBarItem(title: config.title, image: config.icon, tag: index)
        }
        self.viewControllers = controllers
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private struct TabBarConfig {
    let title: String
    let icon: UIImage
}
