//
//  Product.swift
//  Entities
//
//  Created by Frederik Christensen on 08/06/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation

public struct Product: Codable {
    public let id: Int
    public let price: Int
    public let numberOfTickets: Int
    public let name: String
    public let description: String
}
