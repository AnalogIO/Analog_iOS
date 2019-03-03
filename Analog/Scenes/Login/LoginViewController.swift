//
//  LoginViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Entities

class LoginViewController: UIViewController {

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let passwordInput = Views.passwordInput()
    private let imageView = Views.imageView()
    private let createUserButton = Views.createUserButton()
    private let emailField = Views.emailField()
    private lazy var indicator = ActivityIndication(container: view)

    private let viewModel: LoginViewModel

    private let sideMargin: CGFloat = 16
    private let passwordMargin: CGFloat = 20

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        passwordInput.delegate = self
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

        viewModel.viewDidLoad()
    }

    private func defineLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMargin),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideMargin),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        // Add arranged subviews to the stack view
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(.spacing(16))
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(.spacing(25))
        stackView.addArrangedSubview(passwordInput)
        stackView.addArrangedSubview(.spacing(16))
        stackView.addArrangedSubview(createUserButton)

        NSLayoutConstraint.activate([
            passwordInput.heightAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func setupTargets() {
        createUserButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func navigateToRegister() {
        let registerVC = RegisterViewController(viewModel: RegisterViewModel())
        present(registerVC, animated: true, completion: nil)
    }

    @objc private func didTapForgotPassword(sender: UIButton) {
        navigateToRegister()
    }

    @objc private func didTapBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension LoginViewController: PasswordInputDelegate {
    func didFinish(_ code: String) {
        viewModel.login(email: emailField.text ?? "", password: code)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func didSetFetchTokenState(state: State<Token>) {
        switch state {
        case .loading:
            indicator.start()
        case .loaded(_):
            indicator.stop()
            let vc = HomeTabBarViewController()
            present(vc, animated: true, completion: nil)
        case .error(let error):
            indicator.stop()
            passwordInput.reset()
            displayMessage(title: "Error", message: error.localizedDescription, actions: [.Ok])
        default:
            break
        }
    }

    func didSetFetchCafeState(state: State<Cafe>) {
        switch state {
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
    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func scrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        scrollView.layer.masksToBounds = false
        return scrollView
    }

    static func passwordInput() -> PasswordInput {
        let view = PasswordInput(numberOfInputFields: 4, sideMargin: 15)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func imageView() -> UIImageView {
        let view = UIImageView(image: #imageLiteral(resourceName: "analog_logo_default"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func createUserButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("login_button_create_user", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Color.espresso, for: .normal)
        button.titleLabel?.font = Font.font(size: 18)
        return button
    }

    static func emailField() -> UITextField {
        let textField = UITextField()
        textField.font = Font.font(size: 18)
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.borderStyle = .none
        textField.tintColor = Color.espresso
        textField.backgroundColor = .clear
        textField.textAlignment = .center
        textField.textColor = Color.espresso
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = UserDefaults.standard.string(forKey: "email") ?? ""
        textField.placeholder = NSLocalizedString("login_email_placeholder", comment: "")
        return textField
    }
}
