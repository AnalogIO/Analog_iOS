//
//  Cafe.swift
//  ShiftPlanningAPI
//
//  Created by Frederik Christensen on 14/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Client
import Entities

extension Cafe {
    public static func isOpen() -> Request<Cafe, ShiftPlanningError> {
        return Request(path: "open/analog")
    }
}
