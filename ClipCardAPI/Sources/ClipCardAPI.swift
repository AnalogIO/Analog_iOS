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
import Entities

public class ClipCardAPI: API {
    
    #if DEBUG
    public var baseUrl: String = "https://analogio.dk/beta/clippy/api/"
    #else
    public var baseUrl: String = "https://analogio.dk/beta/clippy/api/"
    #endif

    let token: String?

    //API Version
    let version = "1.0"
    
    private lazy var headers: HTTPHeaders = {
        var headers: HTTPHeaders = [:]
        if let token = token { headers["Authorization"] = "bearer " + token }
        headers["api-version"] = version
        return headers
    }()
    
    public init(token: String? = nil) {
        self.token = token
        super.init(baseUrl: baseUrl)
        setDefaultHeaders(headers: headers)
    }
}
