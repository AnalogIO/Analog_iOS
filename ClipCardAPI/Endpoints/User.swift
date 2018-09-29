//
//  User.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Client
import Entities

extension User {
    public static func login() -> Request<User, ClipCardError> {
        return Request(path: "account/login")
    }

    public static func register() -> Request<Message, ClipCardError> {
        return Request(path: "account/register")
    }
}
