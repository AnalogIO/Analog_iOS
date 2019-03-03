//
//  Ticket.swift
//  Entities
//
//  Created by Frederik Christensen on 17/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public struct Ticket: Codable {
    public let id: Int
    public let dateCreated: String
    public let dateUsed: String?
    public let productName: String
}
