//
//  PurchaseCollectionViewCell.swift
//  Views
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public class PurchaseCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "PurchaseCell"

    private let label = Views.label()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            ])
    }

    public func configure(config: PurchaseCellConfig) {
        label.text = config.name
    }
}

private enum Views {
    static func label() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

public struct PurchaseCellConfig {
    let name: String

    public init(name: String) {
        self.name = name
    }
}
