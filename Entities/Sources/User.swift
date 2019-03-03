//
//  User.swift
//  Entities
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let id: Int
    public let name: String
    public let programmeId: Int
    public let email: String
    public let privacyActivated: Bool
    public let level: Int
    public let requiredExp: Int
    public let rankAllTime: Int
    public let rankSemester: Int
    public let rankMonth: Int
}
