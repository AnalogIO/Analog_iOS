//
//  LoginViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import LocalAuthentication
import Entities

class LoginViewController: UIViewController {

    private let stackView = Views.stackView()
    private let forgotPassword = Views.forgotPasswordButton()
    private let keyboard = Views.numberKeyboard()
    private let imageView = Views.imageView()
    private let createUserButton = Views.createUserButton()
    private let emailField = Views.emailField()

    private lazy var indicator = ActivityIndication(container: view)

    private lazy var passwordInput: PasswordInput = {
        let view = PasswordInput(numberOfInputFields: 4, sideMargin: passwordMargin)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    private let viewModel: LoginViewModel

    private let keyboardMargin: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.25 : 0
    private let sideMargin: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.25 : 20
    private let passwordMargin: CGFloat = 25

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        passwordInput.delegate = self
        keyboard.delegate = passwordInput
        emailField.delegate = self
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey

        defineLayout()
        setupTargets()

        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let email = KeyChainService.shared.get(key: .email) {
            emailField.text = email
        } else {
            emailField.becomeFirstResponder()
        }

        viewModel.viewWillAppear()
    }

    private func defineLayout() {
        view.addSubview(keyboard)
        NSLayoutConstraint.activate([
            keyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: keyboardMargin),
            keyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -keyboardMargin),
            keyboard.heightAnchor.constraint(equalToConstant: 220),
            keyboard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMargin),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideMargin),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: keyboard.topAnchor, constant: -20),
        ])

        stackView.addArrangedSubview(.spacing(10, required: false))
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(.spacing(20, required: false))
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordInput)
        stackView.addArrangedSubview(createUserButton)
        stackView.addArrangedSubview(.emptySpace())

        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: 30),
            createUserButton.heightAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])

        view.addSubview(forgotPassword)
        NSLayoutConstraint.activate([
            forgotPassword.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forgotPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupTargets() {
        createUserButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func navigateToRegister() {
        let registerVC = RegisterViewController(viewModel: RegisterViewModel())
        present(registerVC, animated: true, completion: {
            self.passwordInput.reset()
        })
    }

    private func navigateToHome() {
        let vc = HomeTabBarViewController()
        present(vc, animated: true, completion: {
            self.passwordInput.reset()
        })
    }

    @objc private func didTapForgotPassword(sender: UIButton) {
        requestInput(title: "Forgot PIN", message: "Please enter your email address. You will receive an email that you will have to confirm.", completion: { email in
            guard let email = email else { return }
            self.viewModel.forgotPassword(email: email)
        })
    }

    @objc private func didTapRegister(sender: UIButton) {
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
    func didSetFetchForgotPasswordState(state: State<Message>) {
        switch state {
        case .loading:
            indicator.start()
        case .loaded(let message):
            indicator.stop()
            displayMessage(title: "Message", message: message.message, actions: [.Ok])
        case .error(let error):
            indicator.stop()
            displayMessage(title: "Message", message: error.localizedDescription, actions: [.Ok])
        default:
            break
        }
    }

    func showMessage(text: String) {
        displayMessage(title: "Message", message: text, actions: [.Ok])
    }

    func startFaceTouchAuthentication() {
        let context = LAContext()
        let reason = "Log in to your account"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.viewModel.loginWithStoredCredentials()
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        } else {
            displayMessage(title: "Message", message: error?.localizedDescription ?? "Something went wrong with Face/Touch ID", actions: [.Ok])
        }
    }

    func didSetFetchTokenState(state: State<Token>) {
        switch state {
        case .loading:
            indicator.start()
        case .loaded(_):
            indicator.stop()
            navigateToHome()
        case .error(let error):
            indicator.stop()
            passwordInput.reset()
            displayMessage(title: "Message", message: error.localizedDescription, actions: [.Ok])
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }
}

private enum Views {
    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    static func numberKeyboard() -> NumberKeyboard {
        let view = NumberKeyboard()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func imageView() -> UIImageView {
        let view = UIImageView(image: #imageLiteral(resourceName: "analog_logo_default"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }

    static func createUserButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(.localized(.loginButtonCreateUser), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Color.espresso, for: .normal)
        button.titleLabel?.font = Font.font(size: 18)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }

    static func forgotPasswordButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Forgot PIN", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Color.espresso, for: .normal)
        button.titleLabel?.font = Font.font(size: 14)
        return button
    }

    static func emailField() -> UITextField {
        let textField = UITextField()
        textField.font = Font.font(size: 18)
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.borderStyle = .none
        textField.tintColor = Color.espresso
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.textAlignment = .center
        textField.textColor = Color.espresso
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = .localized(.loginEmailPlaceholder)
        return textField
    }
}
