//
//  VoucherViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class VoucherViewController: UIViewController {

    let input = Views.inputView()

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

    private func defineLayout() {
        view.addSubview(input)
        NSLayoutConstraint.activate([
            input.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            input.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            input.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            input.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {}
}

extension VoucherViewController: VoucherViewModelDelegate {}

private enum Views {
    static func inputView() -> InputView {
        let view = InputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        #warning("localization needed")
        view.titleLabel.text = "Redeem Voucher"
        #warning("localization needed")
        view.descriptionLabel.text = "Voucher description"
        #warning("localization needed")
        view.textField.placeholder = "Enter code"
        return view
    }
}
