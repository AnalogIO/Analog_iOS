//
//  Purchase.swift
//  Entities
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public struct Purchase: Codable {
    public let id: Int
    public let productName: String
    public let productId: Int
    public let transactionId: String
    public let price: Int
    public let numberOfTickets: Int
    public let orderId: String
    public let completed: Bool
    public let dateCreated: String
}
