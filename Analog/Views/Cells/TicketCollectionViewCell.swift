//
//  TicketCollectionViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import UIKit

public class TicketCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "TicketCell"

    private let label = Views.title()

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
    
    public func configure(config: TicketCellConfig) {
        label.text = config.name
    }
}

private enum Views {
    static func title() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.minimumScaleFactor = 0.1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

public struct TicketCellConfig {
    let name: String

    public init(name: String) {
        self.name = name
    }
}
