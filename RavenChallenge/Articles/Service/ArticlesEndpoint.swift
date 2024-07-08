//
//  ArticlesEndpoint.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import Foundation

public enum ArticlesEndpoint: EndPointType {
    
    case mostPopularArticles(type: String, period: Int)
    
    public var baseURL: String {
        return "https://api.nytimes.com/svc/mostpopular/v2/"
    }
    
    public var path: String {
        switch self {
        case .mostPopularArticles(type: let type, period: let period):
            return "\(type)/\(period).json"
        }
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    public var encoding: ParameterEncoding {
        return .url
    }
}
