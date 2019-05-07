//
//  UpdateUserViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 03/03/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation
import Client
import Entities

enum UpdateType: String {
    case email
    case name
    case password
}

class UpdateUserViewController: UIViewController {

    lazy var indicator = ActivityIndication(container: view)

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let titleLabel = Views.titleLabel()
    private let saveButton = Views.saveButton()
    private let inputField = Views.inputField()
    private let passwordInput = Views.passwordInput()
    private let keyboard = Views.numberKeyboard()

    private let topMargin: CGFloat = 30
    private let sideMargin: CGFloat = 25
    private let saveButtonMargin: CGFloat = 30
    private let inputFieldHeight: CGFloat = 50
    private let saveButtonHeight: CGFloat = 40
    private let imageViewHeight: CGFloat = 60
    private let passwordInputSideMargin: CGFloat = 20
    private let passwordInputHeight: CGFloat = 80

    private var password: String?

    private let viewModel: UpdateUserViewModel
    private var type: UpdateType {
        didSet {
            updateView()
        }
    }

    init(viewModel: UpdateUserViewModel, type: UpdateType, initialValue: String? = nil) {
        self.viewModel = viewModel
        self.type = type
        self.inputField.text = initialValue
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey
        passwordInput.delegate = self
        keyboard.delegate = passwordInput

        defineLayout()
        setupTargets()

        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder()
    }

    private func defineLayout() {
        view.addSubview(keyboard)
        NSLayoutConstraint.activate([
            keyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboard.heightAnchor.constraint(equalToConstant: 220),
            keyboard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideMargin),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideMargin),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            stackView.bottomAnchor.constraint(equalTo: keyboard.topAnchor, constant: -20),
        ])

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(.spacing(25))

        switch type {
        case .email, .name:
            defineTextInputLayout()
        case .password:
            definePasswordLayout()
        }

        stackView.addArrangedSubview(.emptySpace())
    }

    private func defineTextInputLayout() {
        stackView.addArrangedSubview(inputField)
        stackView.addArrangedSubview(.spacing(25))
        stackView.addArrangedSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: saveButtonHeight),
            saveButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: saveButtonMargin),
            saveButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -saveButtonMargin),
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
        saveButton.addTarget(self, action: #selector(didPressNextButton), for: .touchUpInside)
    }

    @objc func didPressNextButton(sender: UIButton) {
        guard let input = inputField.text else {
            return
        }
        viewModel.updateUser(type: type, value: input)
    }

    private func updateView() {
        switch type {
        case .email:
            titleLabel.text = .localized(.createUserEmailTitle)
            keyboard.isHidden = true
        case .name:
            titleLabel.text = .localized(.createUserNameTitle)
            keyboard.isHidden = true
        case .password:
            titleLabel.text = .localized(.updateUserPinTitle)
            keyboard.isHidden = false
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

extension UpdateUserViewController: PasswordInputDelegate {
    func didFinish(_ code: String) {
        guard let password = password else {
            titleLabel.text = .localized(.updateUserPinConfirmTitle)
            passwordInput.reset()
            self.password = code
            return
        }

        if password == code {
            viewModel.updateUser(type: .password, value: password)
            passwordInput.reset()
        } else {
            displayMessage(title: "Message", message: "Password did not match", actions: [.Ok])
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
        stackView.distribution = .fill
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

    static func numberKeyboard() -> NumberKeyboard {
        let view = NumberKeyboard()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func saveButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = Color.yellow
        button.setTitle(.localized(.updateUserSaveButton), for: .normal)
        button.setTitleColor(Color.milk, for: .normal)
        button.titleLabel?.font = Font.boldFont(size: 18)
        button.addShadow()
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
}

extension UpdateUserViewController: UpdateUserViewModelDelegate {
    func didUpdateUserState(state: State<User>) {
        switch state {
        case .loaded(_):
            indicator.stop()
            navigationController?.popViewController(animated: true)
        case .error(let error):
            indicator.stop()
            displayMessage(title: "Message", message: error.localizedDescription, actions: [.Ok])
        case .loading:
            indicator.start()
        default:
            break
        }
    }
}
