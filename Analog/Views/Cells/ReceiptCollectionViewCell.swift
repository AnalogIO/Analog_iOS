//
//  ReceiptCollectionViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 24/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public class ReceiptCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "ReceiptCell"

    private let label = Views.label()
    private let dateLabel = Views.dateLabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        self.layer.cornerRadius = 4
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.3
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])

        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    public func configure(config: ReceiptCellConfig) {
        label.text = config.name
        dateLabel.text = config.date
    }
}

private enum Views {
    static func label() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Font.font(size: 19)
        label.textColor = Color.espresso
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func dateLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Font.font(size: 14)
        label.textColor = Color.espresso
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

public struct ReceiptCellConfig {
    let name: String
    let date: String

    public init(name: String, date: String) {
        self.name = name
        self.date = date
    }
}
