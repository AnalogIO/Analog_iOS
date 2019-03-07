//
//  InputViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 03/03/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation

enum InputType {
    case email
    case name
    case password
}

protocol InputViewControllerDelegate: class {
    func didPressLoginButton()
    func didReceiveInput(type: InputType, input: String)
}

class InputViewController: UIViewController {

    public weak var delegate: InputViewControllerDelegate?

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let titleLabel = Views.titleLabel()
    private let nextButton = Views.nextButton()
    private let loginButton = Views.loginButton()
    private let inputField = Views.inputField()
    private let imageView = Views.imageView()
    private let passwordInput = Views.passwordInput()

    private let topMargin: CGFloat = 30
    private let sideMargin: CGFloat = 25
    private let nextButtonMargin: CGFloat = 30
    private let inputFieldHeight: CGFloat = 50
    private let nextButtonHeight: CGFloat = 40
    private let imageViewHeight: CGFloat = 60
    private let passwordInputSideMargin: CGFloat = 20
    private let passwordInputHeight: CGFloat = 80

    private var password: String?

    private var type: InputType {
        didSet {
            updateView()
        }
    }

    init(type: InputType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.backgroundGray
        passwordInput.delegate = self

        defineLayout()
        setupTargets()

        updateView()
    }

    private func defineLayout() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMargin),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideMargin),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(.spacing(40))
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(.spacing(25))

        switch type {
        case .email, .name:
            defineTextInputLayout()
        case .password:
            definePasswordLayout()
        }

        stackView.addArrangedSubview(.spacing(30))
        stackView.addArrangedSubview(loginButton)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
        ])
    }

    private func defineTextInputLayout() {
        stackView.addArrangedSubview(inputField)
        stackView.addArrangedSubview(.spacing(25))
        stackView.addArrangedSubview(nextButton)

        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: nextButtonHeight),
            nextButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: nextButtonMargin),
            nextButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -nextButtonMargin),
            inputField.heightAnchor.constraint(equalToConstant: inputFieldHeight),
            inputField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }

    private func definePasswordLayout() {
        stackView.addArrangedSubview(passwordInput)

        NSLayoutConstraint.activate([
            passwordInput.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: passwordInputSideMargin),
            passwordInput.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -passwordInputSideMargin),
            passwordInput.heightAnchor.constraint(equalToConstant: passwordInputHeight),
        ])
    }

    private func setupTargets() {
        loginButton.addTarget(self, action: #selector(didPressLoginButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didPressNextButton), for: .touchUpInside)
    }

    @objc func didPressLoginButton(sender: UIButton) {
        delegate?.didPressLoginButton()
    }

    @objc func didPressNextButton(sender: UIButton) {
        guard let input = inputField.text else {
            return
        }
        delegate?.didReceiveInput(type: type, input: input)
    }

    private func updateView() {
        switch type {
        case .email:
            titleLabel.text = .localized(.createUserEmailTitle)
        case .name:
            titleLabel.text = .localized(.createUserNameTitle)
        case .password:
            titleLabel.text = .localized(.createUserPinTitle)
        }
    }

    public func reset() {
        switch type {
        case .name, .email:
            inputField.text = nil
        case .password:
            passwordInput.reset()
        }
    }
}

extension InputViewController: PasswordInputDelegate {
    func didFinish(_ code: String) {
        guard let password = password else {
            titleLabel.text = .localized(.createUserPinConfirmTitle)
            passwordInput.reset()
            self.password = code
            return
        }

        if password == code {
            delegate?.didReceiveInput(type: type, input: password)
        } else {
            passwordInput.reset()
        }
    }
}

private enum Views {
    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
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
        let view = PasswordInput(numberOfInputFields: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func nextButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.yellow
        button.setTitle(.localized(.createUserContinueButton), for: .normal)
        button.setTitleColor(Color.milk, for: .normal)
        button.titleLabel?.font = Font.boldFont(size: 18)
        button.addShadow()
        return button
    }

    static func loginButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(.localized(.createUserAlreadyGotAccount), for: .normal)
        button.setTitleColor(Color.cortado, for: .normal)
        button.titleLabel?.font = Font.font(size: 16)
        return button
    }

    static func inputField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Color.milk
        textField.addShadow()
        textField.layer.cornerRadius = 4
        textField.textAlignment = .center
        textField.tintColor = Color.espresso
        textField.borderStyle = .none
        return textField
    }

    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldFont(size: 28)
        label.textAlignment = .center
        label.textColor = Color.espresso
        return label
    }

    static func imageView() -> UIImageView {
        let view = UIImageView(image: #imageLiteral(resourceName: "analog_logo_default"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
