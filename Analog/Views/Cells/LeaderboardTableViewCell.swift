//
//  LeaderboardTableViewCell.swift
//  Analog
//
//  Created by Frederik Christensen on 08/10/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public class LeaderboardTableViewCell: UITableViewCell {
    public static let reuseIdentifier: String = "LeaderboardCell"

    public func configure(config: LeaderboardTableViewCellConfig) {
        textLabel?.text = config.name
    }
}

public struct LeaderboardTableViewCellConfig {
    public let name: String
    public let score: Int

    public init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}
