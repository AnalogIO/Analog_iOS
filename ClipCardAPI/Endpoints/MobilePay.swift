//
//  MobilePay.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 30/11/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Client
import Entities

public enum MobilePay {
    public static func initiatePurchase() -> Request<MPOrder, ClipCardError> {
        return Request(path: "mobilepay/initiate")
    }

    public static func completePurchase() -> RequestNoContent<ClipCardError> {
        return RequestNoContent(path: "mobilepay/complete")
    }
}
