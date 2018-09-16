//
//  ClipCardAPI.swift
//  ClipCardAPI
//
//  Created by Frederik Christensen on 26/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Alamofire
import Client

public class ClipCardAPI: API {
    
    #if DEBUG
    public var baseUrl: String = "http://frederikjorgensen.dk/coffeecard/api/"
    #else
    public var baseUrl: String = "https://analogio.dk/coffeecard/api/"
    #endif
    
    private lazy var headers: HTTPHeaders = {
        return [
            :
        ]
    }()
    
    public init() {
        super.init(baseUrl: baseUrl)
        setDefaultHeaders(headers: headers)
    }
}
