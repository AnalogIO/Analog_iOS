//
//  Message.swift
//  Entities
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

public struct ValueMessage: Codable {
    public let message: String

    enum RootKeys: String, CodingKey {
        case value
    }

    enum ValueKeys: String, CodingKey {
        case message
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let valueContainer = try container.nestedContainer(keyedBy: ValueKeys.self, forKey: .value)
        message = try valueContainer.decode(String.self, forKey: .message)
    }
}
