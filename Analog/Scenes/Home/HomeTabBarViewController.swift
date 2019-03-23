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
        TabBarConfig(title: "Profile", icon: #imageLiteral(resourceName: "Profile")),
        TabBarConfig(title: "Receipts", icon: #imageLiteral(resourceName: "Receipts")),
        TabBarConfig(title: "Leaderboard", icon: #imageLiteral(resourceName: "leaderboard_icon")),
        TabBarConfig(title: "More", icon: #imageLiteral(resourceName: "More")),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureTabBar()
    }

    func configureNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    func configureTabBar() {
        tabBar.tintColor = Color.espresso
        tabBar.barTintColor = Color.milk
        let controllers: [UIViewController] = [
            UINavigationController(rootViewController: TicketsViewController(viewModel: TicketsViewModel())),
            UINavigationController(rootViewController: ProfileViewController()),
            UINavigationController(rootViewController: ReceiptsViewController(viewModel: ReceiptsViewModel())),
            UINavigationController(rootViewController: LeaderboardViewController(viewModel: LeaderboardViewModel())),
            UINavigationController(rootViewController: MoreViewController(viewModel: MoreViewModel())),
        ]
        controllers.enumerated().forEach { (index, vc) in
            let config = tabBarConfigs[index]
            vc.tabBarItem = UITabBarItem(title: config.title, image: config.icon, tag: index)
        }
        self.viewControllers = controllers
    }
}

private struct TabBarConfig {
    let title: String
    let icon: UIImage
}
