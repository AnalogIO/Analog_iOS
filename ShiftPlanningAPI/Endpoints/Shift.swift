//
//  Shift+Decodable.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Entities
import Client

extension Shift {
    public static func getShift(shiftId: Int) -> Request<Shift, ShiftPlanningError> {
        return Request(path: "shifts/\(shiftId)")
    }
}
