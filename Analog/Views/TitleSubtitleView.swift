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

    init() {
        super.init(frame: .zero)

        defineLayout()
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
            number.topAnchor.constraint(equalTo: title.bottomAnchor),
            number.leadingAnchor.constraint(equalTo: leadingAnchor),
            number.trailingAnchor.constraint(equalTo: trailingAnchor),
            number.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

private enum Views {
    static func title() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.font(size: 18)
        label.textColor = Color.espresso
        label.textAlignment = .center
        return label
    }

    static func number() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = Font.font(size: 40)
        label.textColor = Color.espresso
        label.textAlignment = .center
        return label
    }
}
