//
//  AccountNetwork.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 15/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
// 

import Foundation
import Alamofire
import Client

public class ShiftPlanningAPI: API {

    #if DEBUG
    public var baseUrl: String = "https://analogio.dk/beta/publicshiftplanning/api/"
    #else
    public var baseUrl: String = "https://analogio.dk/publicshiftplanning/api/"
    #endif
    
    public lazy var headers: HTTPHeaders = {
        return [:]
    }()
    
    public init() {
        super.init(baseUrl: baseUrl)
        setDefaultHeaders(headers: headers)
    }
}
