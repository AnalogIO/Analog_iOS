//
//  RegisterViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class RegisterViewController: UIViewController {

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let titleLabel = Views.titleLabel()
    private let nameField = Views.nameField()
    private let emailField = Views.emailField()
    private let passwordInput = Views.passwordInput()
    private let programmePicker = Views.programmePicker()
    private let registerButton = Views.registerButton()

    let margin: CGFloat = 16

    var programmes: [Programme] = [] {
        didSet {
            programmePicker.reloadAllComponents()
        }
    }

    let viewModel: RegisterViewModel

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        programmePicker.delegate = self
        programmePicker.dataSource = self
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
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
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
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(passwordInput)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(programmePicker)
        stackView.addArrangedSubview(.spacing(500, required: false))
        stackView.addArrangedSubview(registerButton)

        NSLayoutConstraint.activate([
            passwordInput.heightAnchor.constraint(equalToConstant: 100),
            programmePicker.heightAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupTargets() {
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func didTapRegisterButton(sender: UIButton) {
        guard let name = nameField.text, name != "",
              let email = emailField.text, email != "",
              passwordInput.password.count == 4 else {
            print("Fill in required fields...")
            return
        }
        let programme = programmes[programmePicker.selectedRow(inComponent: 0)]
        viewModel.register(name: name, email: email, password: passwordInput.password, programme: programme)
    }

    @objc private func didTapBackground(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func didSetRegisterState(state: State<Message>) {
        switch state {
        case .loading:
            print("Loading...")
        case .loaded(let value):
            print(value)
            let vc = LoginViewController(viewModel: LoginViewModel())
            present(vc, animated: true, completion: nil)
        case .error(let error):
            print(error)
        default:
            break
        }
    }

    func didSetFetchProgrammesState(state: State<[Programme]>) {
        switch state {
        case .loading:
            print("Loading...")
        case .loaded(let value):
            programmes = value
        case .error(let error):
            print(error)
        default:
            break
        }
    }
}

extension RegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return programmes[row].fullName
    }
}

extension RegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return programmes.count
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
        return scrollView
    }

    static func titleLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.boldFont(size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = NSLocalizedString("register_title", comment: "")
        return label
    }

    static func nameField() -> UITextField {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Font.font(size: 16)
        view.borderStyle = .roundedRect
        view.placeholder = NSLocalizedString("register_name_placeholder", comment: "")
        return view
    }

    static func emailField() -> UITextField {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Font.font(size: 16)
        view.borderStyle = .roundedRect
        view.placeholder = NSLocalizedString("register_email_placeholder", comment: "")
        return view
    }

    static func passwordInput() -> PasswordInput {
        let view = PasswordInput(numberOfInputFields: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    static func programmePicker() -> UIPickerView {
        let view = UIPickerView()
        return view
    }

    static func registerButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = Color.buttonBackground
        button.setTitleColor(Color.buttonText, for: .normal)
        button.titleLabel?.font = Font.boldFont(size: 17)
        button.setTitle(NSLocalizedString("register_button_register", comment: ""), for: .normal)
        return button
    }
}
