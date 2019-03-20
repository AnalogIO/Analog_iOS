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

    private let title = Views.title()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        self.layer.cornerRadius = 10
        self.addShadow()
        self.backgroundColor = .white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    public func configure(config: TicketCellConfig) {
        title.text = config.name
    }
}

private enum Views {
    static func title() -> UILabel {
        let title = UILabel()
        title.textAlignment = .center
        title.font = Font.font(size: 24)
        title.minimumScaleFactor = 0.1
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }
}

public struct TicketCellConfig {
    let name: String

    public init(name: String) {
        self.name = name
    }
}
