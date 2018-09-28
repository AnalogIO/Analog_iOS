//
//  VoucherViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class VoucherViewController: UIViewController {

    let viewModel: VoucherViewModel

    lazy var indicator = ActivityIndication(container: view)

    init(viewModel: VoucherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Voucher"
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    private func defineLayout() {}

    private func setupTargets() {}
}

extension VoucherViewController: VoucherViewModelDelegate {}

private enum Views {}
