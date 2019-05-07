//
//  Token.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 07/05/2019.
//  Copyright © 2019 analogio. All rights reserved.
//

import Foundation
import Client
import Entities

extension Token {
    public static func verify() -> RequestNoContent<ClipCardError> {
        return RequestNoContent(path: "account/verify")
    }
}
