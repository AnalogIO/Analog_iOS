//
//  PurchaseCollectionViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public class PurchaseCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "PurchaseCell"

    private let label = Views.label()
    private let dateLabel = Views.dateLabel()
    private let priceLabel = Views.priceLabel()

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

        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    public func configure(config: PurchaseCellConfig) {
        label.text = config.name
        dateLabel.text = config.date
        priceLabel.text = "\(config.price) DKK"
    }
}

private enum Views {
    static func label() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Font.font(size: 20)
        label.textColor = Color.espresso
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func dateLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Font.font(size: 20)
        label.textColor = Color.espresso
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func priceLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Font.font(size: 20)
        label.textColor = Color.espresso
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

public struct PurchaseCellConfig {
    let name: String
    let date: String
    let price: Int

    public init(name: String, date: String, price: Int) {
        self.name = name
        self.date = date
        self.price = price
    }
}
