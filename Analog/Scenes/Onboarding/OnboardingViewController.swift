//
//  OnboardingViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 12/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit
import Views
import Entities

class OnboardingViewController: UIViewController {

    let scrollView = Views.scrollView()
    let stackView = Views.stackView()
    let nameField = Views.nameField()
    let emailField = Views.emailField()
    let passwordInput = Views.passwordInput()
    let programmePicker = Views.programmePicker()
    let registerButton = Views.registerButton()

    let margin: CGFloat = 16

    var programmes: [Programme] = [] {
        didSet {
            programmePicker.reloadAllComponents()
        }
    }
    var password: String?

    let viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        programmePicker.delegate = self
        programmePicker.dataSource = self
        passwordInput.delegate = self
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
        ])

        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: margin).isActive = true
        }

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Add arranged subviews to the stack view
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(passwordInput)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(programmePicker)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(registerButton)

        NSLayoutConstraint.activate([
            passwordInput.heightAnchor.constraint(equalToConstant: 100),
            programmePicker.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    func setupTargets() {
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }

    @objc func didTapRegisterButton(sender: UIButton) {
        guard let name = nameField.text, let email = emailField.text, let password = password else {
            print("Fill in required fields...")
            return
        }
        let programme = programmes[programmePicker.selectedRow(inComponent: 0)]
        viewModel.register(name: name, email: email, password: password, programme: programme)
    }
}

extension OnboardingViewController: OnboardingViewModelDelegate {
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

extension OnboardingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return programmes[row].fullName
    }
}

extension OnboardingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return programmes.count
    }
}

extension OnboardingViewController: PasswordInputDelegate {
    func didFinish(_ code: String) {
        self.password = code
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

    static func nameField() -> UITextField {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Font.font(size: 16)
        view.borderStyle = .roundedRect
        view.placeholder = NSLocalizedString("onboarding_name_placeholder", comment: "")
        return view
    }

    static func emailField() -> UITextField {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Font.font(size: 16)
        view.borderStyle = .roundedRect
        view.placeholder = NSLocalizedString("onboarding_email_placeholder", comment: "")
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
        button.setTitle(NSLocalizedString("onboarding_button_register", comment: ""), for: .normal)
        return button
    }
}

private extension UIView {
    static func spacing(_ height: CGFloat, required: Bool = true, priority: UILayoutPriority = .required) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if required {
            let constraint = view.heightAnchor.constraint(equalToConstant: height)
            constraint.priority = priority
            constraint.isActive = true
        } else {
            let constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: height)
            constraint.priority = priority
            constraint.isActive = true
        }
        return view
    }
}
