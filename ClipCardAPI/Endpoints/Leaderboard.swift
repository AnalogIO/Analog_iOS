//
//  Leaderboard.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 08/10/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Entities
import Client

public enum Leaderboard {
    public static func get(type: LeaderboardType) -> Request<[LeaderboardUser], ClipCardError> {
        return Request(path: "leaderboard?preset=\(type.rawValue)")
    }
}

public enum LeaderboardType: Int {
    case month = 0
    case semester = 1
    case all = 2
}
