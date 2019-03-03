//
//  Programme.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 16/09/2018.
//  Copyright © 2018 analogio. All rights reserved.
//

import Foundation
import Entities
import Client

extension Programme {
    public static func getAll() -> Request<[Programme], ClipCardError> {
        return Request(path: "programmes")
    }

    public static func get(id: Int) -> Request<Programme, ClipCardError> {
        return Request(path: "programmes/\(id)")
    }
}
