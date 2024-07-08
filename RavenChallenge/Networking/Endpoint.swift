//
//  Endpoint.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//
import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // Agrega otros métodos HTTP que necesites
}

public enum ParameterEncoding {
    case url
    case json
    // Agrega otros tipos de codificación que necesites
}

public typealias HTTPHeaders = [String: String]

public protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}
