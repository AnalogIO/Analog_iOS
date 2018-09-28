//
//  HelpViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class HelpViewController: UIViewController {

    let viewModel: HelpViewModel

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: HelpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Help"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    private func defineLayout() {}

    private func setupTargets() {}
}

extension HelpViewController: HelpViewModelDelegate {}

private enum Views {}
