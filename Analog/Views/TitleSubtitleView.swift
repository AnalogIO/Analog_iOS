//
//  TitleSubtitleView.swift
//  Views
//
//  Created by Frederik Christensen on 20/02/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import UIKit

public enum TitleSubtitleViewType {
    case button
    case text
}

public class TitleSubtitleView: UIView {

    let title = Views.title()
    let button = Views.button()
    let number = Views.number()

    var type: TitleSubtitleViewType {
        didSet {
            self.typeDidChange(to: type)
        }
    }

    init(type: TitleSubtitleViewType) {
        self.type = type
        super.init(frame: .zero)

        defineLayout()
        setupTargets()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        addSubview(number)
        NSLayoutConstraint.activate([
            number.topAnchor.constraint(equalTo: topAnchor),
            number.leadingAnchor.constraint(equalTo: leadingAnchor),
            number.trailingAnchor.constraint(equalTo: trailingAnchor),
            number.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupTargets() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton(sender: UIButton) {
        print("button pressed")
    }

    private func typeDidChange(to type: TitleSubtitleViewType) {
        switch type {
        case .text:
            number.isHidden = false
            button.isHidden = true
        case .button:
            break
        }
    }
}

private enum Views {
    static func title() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 14)
        return label
    }

    static func number() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = Font.font(size: 40)
        return label
    }

    static func button() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
