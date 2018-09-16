//
//  PasswordInput.swift
//  Views
//
//  Created by Frederik Christensen on 14/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public protocol PasswordInputDelegate: class {
    func didFinish(_ code: String)
}

public class PasswordInput: UIView {

    private let stackView = Views.stackView()
    public weak var delegate: PasswordInputDelegate?
    private var currentInput = 0
    private var password = ""
    private var numberOfInputFields: Int
    private var inputFields:[UITextField] = []

    public init(numberOfInputFields: Int) {
        self.numberOfInputFields = numberOfInputFields
        super.init(frame: .zero)
        defineLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        configureSubviews()
    }

    func configureSubviews() {
        addSubview(stackView)
        for _ in 1...self.numberOfInputFields {
            let inputField = UITextField()
            inputField.borderStyle = .roundedRect
            inputField.textAlignment = .center
            inputField.isEnabled = false
            inputField.font = UIFont.systemFont(ofSize: 40)
            stackView.addArrangedSubview(inputField)
            self.inputFields.append(inputField)
        }
    }

    open override var canBecomeFirstResponder : Bool {
        return true
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }

    open var keyboardType: UIKeyboardType { get { return .numberPad } set { } }
}

extension PasswordInput: UIKeyInput {
    public var hasText: Bool {
        return currentInput > 0 ? true : false
    }

    public func insertText(_ text: String) {
        if currentInput >= numberOfInputFields { return }
        self.inputFields[currentInput].text = "‌\u{2022}"
        self.password += text
        currentInput += 1
        if currentInput == numberOfInputFields {
            self.delegate?.didFinish(self.password)
        }
    }

    public func deleteBackward() {
        if currentInput == 0 { return }
        currentInput -= 1
        self.inputFields[currentInput].text = ""
        self.password = self.password.dropLast().description
    }
}

private enum Views {
    static func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .horizontal
        return stackView
    }
}
