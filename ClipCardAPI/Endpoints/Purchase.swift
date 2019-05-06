//
//  Purchase.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 28/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation

import Entities
import Client

extension Purchase {
    public static func getAll() -> Request<[Purchase], ClipCardError> {
        return Request(path: "purchases")
    }

    public static func redeemVoucher() -> Request<Purchase, ClipCardError> {
        return Request(path: "purchases/redeemvoucher")
    }
}
