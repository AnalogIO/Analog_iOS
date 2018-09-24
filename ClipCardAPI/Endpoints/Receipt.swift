//
//  Receipt.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 24/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Entities
import Client

public enum Receipt {
    public static func getAll() -> Request<[Ticket], ClipCardError> {
        return Request(path: "tickets/used")
    }
}
