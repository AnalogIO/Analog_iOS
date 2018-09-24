//
//  Ticket.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 21/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

import Entities
import Client

extension Ticket {
    public static func getAll() -> Request<[Ticket], ClipCardError> {
        return Request(path: "tickets/unused")
    }
}
