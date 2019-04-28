//
//  Coffeecard.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 24/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation
import Entities
import Client

extension Coffeecard {
    public static func getAll() -> Request<[Coffeecard], ClipCardError> {
        return Request(path: "coffeecards")
    }
}
