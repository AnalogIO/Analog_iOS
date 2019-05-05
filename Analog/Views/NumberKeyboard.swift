//
//  NumberKeyboard.swift
//  Analog
//
//  Created by Frederik Christensen on 05/05/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation

protocol NumberKeyboardDelegate: class {
    func didTap(key: String)
    func didTapDelete()
}

class NumberKeyboard: UIView {

    public weak var delegate: NumberKeyboardDelegate?

    private let spacing: CGFloat = 5

    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = spacing
        return view
    }()

    lazy var row1: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = spacing
        return view
    }()

    lazy var row2: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = spacing
        return view
    }()

    lazy var row3: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = spacing
        return view
    }()

    lazy var row4: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = spacing
        return view
    }()

    init() {
        super.init(frame: .zero)

        defineLayout()
        setupTargets()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
        ])

        stackView.addArrangedSubview(row1)
        stackView.addArrangedSubview(row2)
        stackView.addArrangedSubview(row3)
        stackView.addArrangedSubview(row4)

        row1.addArrangedSubview(button(text: "1"))
        row1.addArrangedSubview(button(text: "2"))
        row1.addArrangedSubview(button(text: "3"))

        row2.addArrangedSubview(button(text: "4"))
        row2.addArrangedSubview(button(text: "5"))
        row2.addArrangedSubview(button(text: "6"))

        row3.addArrangedSubview(button(text: "7"))
        row3.addArrangedSubview(button(text: "8"))
        row3.addArrangedSubview(button(text: "9"))

        row4.addArrangedSubview(empty())
        row4.addArrangedSubview(button(text: "0"))
        row4.addArrangedSubview(back())
    }

    private func setupTargets() {

    }

    private func empty() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }

    private func back() -> UIView {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.setImage(#imageLiteral(resourceName: "keyboard_back").withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = Color.espresso
        view.backgroundColor = Color.milk
        view.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        return view
    }

    private func button(text: String) -> UIView {
        let view = KeyboardButton(value: text)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.milk
        view.layer.cornerRadius = 4
        view.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return view
    }

    @objc private func didTapBack(sender: UIButton) {
        delegate?.didTapDelete()
    }

    @objc private func didTapButton(sender: KeyboardButton) {
        delegate?.didTap(key: sender.value)
    }
}

private class KeyboardButton: UIButton {

    let value: String

    init(value: String) {
        self.value = value
        super.init(frame: .zero)

        setTitle(value, for: .normal)
        setTitleColor(Color.espresso, for: .normal)
        titleLabel?.font = Font.font(size: 24)
        titleLabel?.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
