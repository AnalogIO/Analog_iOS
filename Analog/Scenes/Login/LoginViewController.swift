//
//  LoginViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class LoginViewController: UIViewController {

    private let passwordInput = Views.passwordInput()
    private let imageView = Views.imageView()
    private let forgotPinButton = Views.forgotPinButton()
    private let emailLabel = Views.emailLabel()

    private let viewModel: LoginViewModel

    private let margin: CGFloat = 16

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        passwordInput.delegate = self
        viewModel.delegate = self
        emailLabel.text = viewModel.email
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    private func defineLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            imageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        if #available(iOS 11.0, *) {
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
        } else {
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true
        }

        view.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: margin),
        ])

        view.addSubview(passwordInput)
        NSLayoutConstraint.activate([
            passwordInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            passwordInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            passwordInput.heightAnchor.constraint(equalToConstant: 100),
            passwordInput.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: margin)
        ])

        view.addSubview(forgotPinButton)
        NSLayoutConstraint.activate([
            forgotPinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPinButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: margin),
        ])
    }

    private func setupTargets() {
        forgotPinButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }

    @objc private func didTapForgotPassword(sender: UIButton) {
        print("Forgot password clicked...")
    }
}

extension LoginViewController: PasswordInputDelegate {
    func didFinish(_ code: String) {
        viewModel.login(password: code)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func didSetFetchTokenState(state: State<Token>) {
        switch state {
        case .loading:
            print("Loading...")
        case .loaded(_):
            let vc = HomeTabBarViewController()
            present(vc, animated: true, completion: nil)
        case .error(let error):
            print(error)
        default:
            break
        }
    }

    func didSetFetchCafeState(state: State<Cafe>) {
        switch state {
        case .loading:
            print("Loading...")
        case .loaded(let value):
            imageView.image = value.open ? #imageLiteral(resourceName: "analog_logo_open") : #imageLiteral(resourceName: "analog_logo_closed")
        case .error(let error):
            print(error)
        default:
            break
        }
    }
}

private enum Views {
    static func passwordInput() -> PasswordInput {
        let view = PasswordInput(numberOfInputFields: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func imageView() -> UIImageView {
        let view = UIImageView(image: #imageLiteral(resourceName: "analog_logo_default"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func forgotPinButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("login_button_forgot_pin", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func emailLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.font(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
