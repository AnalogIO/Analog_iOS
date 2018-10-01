//
//  UpdateUserViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 30/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views

class UpdateUserViewController: UIViewController {
    let input = Views.inputView()

    var type: UserFieldType {
        didSet {
            updateView()
        }
    }

    init(type: UserFieldType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        updateView()
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

    private func updateView() {
        input.titleLabel.text = "Change \(type.rawValue)"
        input.descriptionLabel.text = NSLocalizedString("update_\(type.rawValue)_description", comment: "")
        input.textField.text = UserDefaults.standard.string(forKey: type.rawValue)
    }
}

private enum Views {
    static func inputView() -> InputView {
        let view = InputView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

public enum UserFieldType: String {
    case name
    case pin
    case programme
    case email
}
