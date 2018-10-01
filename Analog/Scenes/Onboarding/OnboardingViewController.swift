//
//  OnboardingViewController.swift
//  Analog
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    private let titleLabel = Views.titleLabel()
    private let descriptionLabel = Views.descriptionLabel()
    private let registerButton = Views.registerButton()
    private let loginButton = Views.loginButton()

    let viewModel: OnboardingViewModel

    let margin: CGFloat = 16

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
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
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(.spacing(margin))
        stackView.addArrangedSubview(registerButton)

        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupTargets() {
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }

    @objc func didTapLoginButton(sendeR: UIButton) {
        let vc = LoginViewController(viewModel: LoginViewModel())
        present(vc, animated: true, completion: nil)
    }

    @objc func didTapRegisterButton(sendeR: UIButton) {
        let vc = RegisterViewController(viewModel: RegisterViewModel())
        present(vc, animated: true, completion: nil)
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldFont(size: 28)
        label.textAlignment = .center
        label.text = NSLocalizedString("onboarding_title", comment: "")
        return label
    }

    static func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = NSLocalizedString("onboarding_description", comment: "")
        return label
    }

    static func registerButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = Color.buttonBackground
        button.setTitleColor(Color.buttonText, for: .normal)
        button.titleLabel?.font = Font.boldFont(size: 17)
        button.setTitle(NSLocalizedString("onboarding_register_button", comment: ""), for: .normal)
        return button
    }

    static func loginButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.backgroundColor = Color.buttonBackground
        button.setTitleColor(Color.buttonText, for: .normal)
        button.titleLabel?.font = Font.boldFont(size: 17)
        button.setTitle(NSLocalizedString("onboarding_login_button", comment: ""), for: .normal)
        return button
    }
}
