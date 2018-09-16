//
//  ResponseNoContent.swift
//  Client
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation

public enum ResponseNoContent<ErrorType: APIError> {
    case success
    case error(Error)
}
