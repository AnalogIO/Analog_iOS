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

    private let tabBarTitles = ["Tickets", "Schedule", "Receipts", "Profile", "More"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureTabBar()
    }

    func configureNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = self.tabBarTitles.first
    }

    func configureTabBar() {
        let controllers: [UIViewController] = [
            UINavigationController(rootViewController: TicketsViewController()),
            UINavigationController(rootViewController: ScheduleViewController()),
            UINavigationController(rootViewController: ReceiptsViewController()),
            UINavigationController(rootViewController: ProfileViewController()),
            UINavigationController(rootViewController: MoreViewController()),
        ]
        controllers.enumerated().forEach { (index, vc) in
            vc.tabBarItem = UITabBarItem(title: tabBarTitles[index], image: nil, tag: index)
        }
        self.viewControllers = controllers
    }
}
