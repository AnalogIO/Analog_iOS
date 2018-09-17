//
//  ShiftPlanningError.swift
//  CheckIn
//
//  Created by Frederik Christensen on 23/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Client

public struct ShiftPlanningError: APIError {
    public let message: String

    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "ShiftPlanningError")
    }
}
