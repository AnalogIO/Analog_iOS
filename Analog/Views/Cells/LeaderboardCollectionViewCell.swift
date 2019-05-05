//
//  LeaderboardCollectionViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 08/10/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import UIKit

public class LeaderboardCollectionViewCell: UICollectionViewCell {
    public static let reuseIdentifier: String = "LeaderboardCell"

    private let label = Views.label()
    private let scoreLabel = Views.scoreLabel()

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

        addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }

    public func configure(config: LeaderboardCollectionViewCellConfig) {
        switch config.number {
        case 1:
            label.text = "\u{1F947} " + config.name
        case 2:
            label.text = "\u{1F948} " + config.name
        case 3:
            label.text = "\u{1F949} " + config.name
        default:
            label.text = config.name
        }

        scoreLabel.text = "\(config.score)"
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

    static func scoreLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Font.font(size: 20)
        label.textColor = Color.espresso
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

public struct LeaderboardCollectionViewCellConfig {
    let name: String
    let score: Int
    let number: Int

    init(name: String, score: Int, number: Int) {
        self.name = name
        self.score = score
        self.number = number
    }
}
