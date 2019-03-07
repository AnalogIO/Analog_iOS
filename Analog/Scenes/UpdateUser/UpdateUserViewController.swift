//
//  UpdateUserViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 30/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class UpdateUserViewController: UIViewController {
    let input = Views.inputView()
    let viewModel: UpdateUserViewModel

    lazy var indicator = ActivityIndication(container: view)

    var type: UserFieldType {
        didSet {
            updateView()
        }
    }

    init(viewModel: UpdateUserViewModel, type: UserFieldType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
        input.delegate = self
        viewModel.delegate = self
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

    private func setupTargets() {
    }

    private func updateView() {
        #warning("localization needed")
        input.titleLabel.text = "Change \(type.rawValue)"
        #warning("localization needed")
        input.descriptionLabel.text = "update description"
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

extension UpdateUserViewController: InputViewDelegate {
    func didPressButton(value: String) {
        viewModel.updateUser(type: type, value: value)
    }
}

extension UpdateUserViewController: UpdateUserViewModelDelegate {
    func didUpdateUserState(state: State<User>) {
        switch state {
        case .loaded(let user):
            indicator.stop()
            print(user)
        case .error(let error):
            indicator.stop()
            print(error.localizedDescription)
        case .loading:
            indicator.start()
        default:
            break
        }
    }
}
