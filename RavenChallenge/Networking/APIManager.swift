//
//  APIManager.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import Foundation

public class APIManager {

    public init() {}

    public func getRequest(type endpoint: EndPointType, parameters: [String: Any]?) -> URLRequest? {
        guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            return nil
        }
        
        if endpoint.encoding == .url, let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        if endpoint.encoding == .json, let parameters = parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
