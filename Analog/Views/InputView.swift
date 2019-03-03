//
//  InputView.swift
//  Views
//
//  Created by Frederik Christensen on 29/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public protocol InputViewDelegate: class {
    func didPressButton(value: String)
}

public class InputView: UIView {

    public weak var delegate: InputViewDelegate?

    private let scrollView = Views.scrollView()
    private let stackView = Views.stackView()
    public let titleLabel = Views.titleLabel()
    public let descriptionLabel = Views.descriptionLabel()
    public let textField = Views.textField()
    private let submitButton = Views.submitButton()

    private let textFieldHeight: CGFloat = 45

    public init() {
        super.init(frame: .zero)

        defineLayout()
        setupTargets()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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
        stackView.addArrangedSubview(.spacing(16))
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(.spacing(16))
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(.spacing(16))
        stackView.addArrangedSubview(submitButton)

        textField.layer.cornerRadius = textFieldHeight / 2
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
        ])
    }

    private func setupTargets() {
        submitButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
    }

    @objc private func didPressButton(sender: UIButton) {
        delegate?.didPressButton(value: textField.text ?? "")
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
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return label
    }

    static func textField() -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .none
        field.backgroundColor = .lightGray
        field.textAlignment = .center
        field.clipsToBounds = true
        return field
    }

    static func descriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    static func submitButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        return button
    }
}
