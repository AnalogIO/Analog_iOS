//
//  ClipCardError.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Client

public struct ClipCardError: APIError {
    let message: String

    public var errorDescription: String? {
        return NSLocalizedString(message, comment: "ClipCardError")
    }
}
