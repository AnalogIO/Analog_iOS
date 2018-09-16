//
//  Response.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 22/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import Foundation

public enum Response<Value: Codable, ErrorType: APIError> {
    case success(Value)
    case error(Error)
}

