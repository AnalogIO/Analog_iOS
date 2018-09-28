//
//  ShopViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class ShopViewController: UIViewController {

    let viewModel: ShopViewModel

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: ShopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shop"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    private func defineLayout() {}

    private func setupTargets() {}
}

extension ShopViewController: ShopViewModelDelegate {}

private enum Views {}
