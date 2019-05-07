//
//  TitleSubtitleView.swift
//  Analog
//
//  Created by Frederik Christensen on 20/02/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import UIKit

public class TitleSubtitleView: UIView {

    let title = Views.title()
    let number = Views.number()
    let stackView = Views.stackView()

    init() {
        super.init(frame: .zero)

        defineLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defineLayout() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(number)
    }
}

private enum Views {
    static func stackView() -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 0
        return view
    }

    static func title() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 15)
        label.textColor = Color.espresso
        label.textAlignment = .center
        return label
    }

    static func number() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldFont(size: 80)
        label.minimumScaleFactor = 0.1
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.textColor = Color.espresso
        label.textAlignment = .center
        return label
    }
}
