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

    public weak var delegate: PasswordInputDelegate?

    private let stackView = Views.stackView()
    private(set) var password: String = ""
    private var inputFields: [UITextField] = []
    private var currentInput: Int = 0 {
        didSet {
            self.updateView()
        }
    }

    private var numberOfInputFields: Int
    private let sideMargin: CGFloat

    public init(numberOfInputFields: Int, sideMargin: CGFloat = 0) {
        self.numberOfInputFields = numberOfInputFields
        self.sideMargin = sideMargin
        super.init(frame: .zero)
        defineLayout()
        configureSubviews()
        updateView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideMargin),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideMargin),
        ])
    }

    func configureSubviews() {
        addSubview(stackView)
        for _ in 1...self.numberOfInputFields {
            let inputField = Views.textField()
            stackView.addArrangedSubview(inputField)
            inputFields.append(inputField)
        }
    }

    private func updateView() {
        inputFields.forEach { $0.backgroundColor = Color.espresso }
        if currentInput >= inputFields.count || !isFirstResponder { return }
        inputFields[currentInput].backgroundColor = Color.milk
    }

    public func reset() {
        inputFields.forEach { $0.text = nil }
        currentInput = 0
        password = ""
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        updateView()
        return true
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        updateView()
        return true
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
        self.inputFields[currentInput].text = "‌\u{25cf}"
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

    static func textField() -> UITextField {
        let inputField = UITextField()
        inputField.borderStyle = .none
        inputField.layer.borderColor = Color.espresso.cgColor
        inputField.layer.borderWidth = 5
        inputField.layer.cornerRadius = 10
        inputField.textAlignment = .center
        inputField.isEnabled = false
        inputField.addShadow()
        inputField.font = UIFont.systemFont(ofSize: 20)
        inputField.textColor = Color.milk
        inputField.textAlignment = .center
        return inputField
    }
}
