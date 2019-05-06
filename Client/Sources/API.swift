//
//  API.swift
//  CheckIn
//
//  Created by Frederik Christensen on 22/05/2018.
//  Copyright © 2018 Frederik Christensen. All rights reserved.
//

import Alamofire

open class API {
    let baseUrl: String
    var defaultHeaders: HTTPHeaders = [:]

    public init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func setDefaultHeaders(headers: HTTPHeaders) {
        self.defaultHeaders = headers
    }
    
    private func mergeHeaders(headers: HTTPHeaders) -> HTTPHeaders {
        let dict: HTTPHeaders = defaultHeaders.merging(headers, uniquingKeysWith: { (first, _) in first })
        return dict
    }
    
    public func response<Resource, ErrorType>(for resource: Request<Resource, ErrorType>, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, response resourceResult: @escaping ((Response<Resource, ErrorType>) -> Void)) {
        guard let url = URL(string: baseUrl.appending(resource.path)) else { return }
        let httpHeaders = mergeHeaders(headers: headers)
        print("URL: \(method.rawValue) \(url)")
        print("Parameters: \(parameters)")
        print("Headers: \(httpHeaders)")
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response: DataResponse<Data>) in
                self.interceptResponse(response: response, url: url)
                switch response.result {
                case .success(let data):
                    do {
                        let value = try JSONDecoder().decode(Resource.self, from: data)
                        resourceResult(.success(value))
                    } catch(let error) {
                        resourceResult(.error(error))
                    }
                case .failure(let error):
                    guard let data = response.data else {
                        resourceResult(.error(error))
                        return
                    }
                    do {
                        let value = try JSONDecoder().decode(ErrorType.self, from: data)
                        resourceResult(.error(value))
                    } catch(_) {
                        resourceResult(.error(error))
                    }
                }
        }
    }
    
    public func responseNoContent<ErrorType>(for resource: RequestNoContent<ErrorType>, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, response result: @escaping ((ResponseNoContent<ErrorType>) -> Void)) {
        guard let url = URL(string: baseUrl.appending(resource.path)) else { return }
        let httpHeaders = mergeHeaders(headers: headers)
        print("URL: \(method.rawValue) \(url)")
        print("Parameters: \(parameters)")
        print("Headers: \(httpHeaders)")
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response: DataResponse<Data>) in
                self.interceptResponse(response: response, url: url)
                switch response.result {
                case .success:
                    result(.success)
                case .failure(let error):
                    guard let data = response.data else {
                        result(.error(error))
                        return
                    }
                    do {
                        let value = try JSONDecoder().decode(ErrorType.self, from: data)
                        result(.error(value))
                    } catch(_) {
                        result(.error(error))
                    }
                }
        }
    }

    open func interceptResponse(response: DataResponse<Data>, url: URL) {}
}
