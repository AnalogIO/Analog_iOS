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
    case pin
}

protocol UpdateUserViewControllerDelegate: class {
    func didPressLoginButton()
    func didReceiveInput(type: UpdateType, input: String)
}

class UpdateUserViewController: UIViewController {

    public weak var delegate: UpdateUserViewControllerDelegate?

    lazy var indicator = ActivityIndication(container: view)

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let titleLabel = Views.titleLabel()
    private let saveButton = Views.saveButton()
    private let inputField = Views.inputField()
    private let passwordInput = Views.passwordInput()

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

    init(viewModel: UpdateUserViewModel, type: UpdateType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey
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

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(.spacing(25))

        switch type {
        case .email, .name:
            defineTextInputLayout()
        case .pin:
            definePasswordLayout()
        }
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
        case .pin:
            titleLabel.text = .localized(.updateUserPinTitle)
        }
    }

    public func reset() {
        switch type {
        case .name, .email:
            inputField.text = nil
        case .pin:
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
