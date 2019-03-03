//
//  LeaderboardUser.swift
//  Entities
//
//  Created by Frederik Christensen on 08/10/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public struct LeaderboardUser: Codable {
    public let name: String
    public let score: Int
}
