//
//  Shift.swift
//  CheckIn
//
//  Created by Frederik Christensen on 18/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation

public struct Shift: Codable {
    public let id: Int
    public let start: String
    public let end: String
    public let employees: [Employee]
    public let scheduleId: Int?
}
