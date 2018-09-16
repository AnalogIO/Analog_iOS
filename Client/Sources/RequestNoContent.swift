//
//  RequestNoContent.swift
//  Client
//
//  Created by Frederik Christensen on 25/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Foundation
import Alamofire

public struct RequestNoContent<ErrorType: APIError> {
    
    public var path: String
    
    public init(path: String) {
        self.path = path
    }
}

extension RequestNoContent {
    public func response(using api: API, method: HTTPMethod, parameters: Parameters = [:], headers: HTTPHeaders = [:], response: @escaping ((ResponseNoContent<ErrorType>) -> Void)) {
        api.responseNoContent(for: self, method: method, parameters: parameters, headers: headers, response: response)
    }
}
