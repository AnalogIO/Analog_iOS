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

public protocol ClipCardAPIDelegate: class {
    func invalidToken()
}

public class ClipCardAPI: API {
    
    #if DEBUG
    public var baseUrl: String = "https://analogio.dk/beta/clippy/api/v1/"
    #else
    public var baseUrl: String = "https://analogio.dk/clippy/api/v1/"
    #endif

    let token: String?

    public weak var delegate: ClipCardAPIDelegate?

    private lazy var headers: HTTPHeaders = {
        var headers: HTTPHeaders = [:]
        if let token = token { headers["Authorization"] = "bearer " + token }
        return headers
    }()

    public init(token: String? = nil) {
        self.token = token
        super.init(baseUrl: baseUrl)
        setDefaultHeaders(headers: headers)
    }

    override public func interceptResponse(response: DataResponse<Data>, url: URL) {
        guard let result = response.response else { return }
        let code: Int = result.statusCode
        let status: String = "\(response.result)"

        //invalid token
        if code == 401 {
            delegate?.invalidToken()
        }

        print("Received response from: \(url) - \(status): \(code)")
    }
}
