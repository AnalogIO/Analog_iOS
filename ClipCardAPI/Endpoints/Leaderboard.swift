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

extension Leaderboard {
    public static func get() -> Request<Leaderboard, ClipCardError> {
        return Request(path: "leaderboard")
    }
}
