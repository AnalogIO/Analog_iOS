//
//  Request.swift
//  ClipCard
//
//  Created by Frederik Dam Christensen on 22/02/2018.
//  Copyright © 2018 Frederik Dam Christensen. All rights reserved.
//

import Foundation
import Alamofire

public struct Request<Resource: Codable, ErrorType: APIError> {
    
    public var path: String
    
    public init(path: String) {
        self.path = path
    }
}

extension Request {
    public func response(using api: API, method: HTTPMethod, parameters: Parameters = [:], headers: HTTPHeaders = [:], response: @escaping ((Response<Resource, ErrorType>) -> Void)) {
        api.response(for: self, method: method, parameters: parameters, headers: headers, response: response)
    }
}
