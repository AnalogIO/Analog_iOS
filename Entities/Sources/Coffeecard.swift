//
//  Coffeecard.swift
//  Entities
//
//  Created by Frederik Christensen on 24/04/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation

public struct Coffeecard: Codable {
    public let productId: Int
    public let name: String
    public let ticketsLeft: Int
    public let price: Int
    public let quantity: Int
}
