//
//  State.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 22/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import Foundation

public enum State<Value> {
    case unknown
    case loading
    case loaded(Value)
    case error(Error)
}
