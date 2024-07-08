//
//  Networking.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import Foundation

protocol NetworkingProtocol {
    func execute<T: Decodable>(_ endpoint: EndPointType, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void)
}

public class Networking: NetworkingProtocol {
    
    // MARK: - Generic Execute function with Decodable Response
    public func execute<T>(_ endpoint: EndPointType, parameters: [String: Any]? = nil, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        
        guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseObject = try decoder.decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
}


//public protocol NetworkingProtocol {
//    func execute<T: Decodable>(_ endpoint: EndPointType, parameters: [String: Any]?, completion: @escaping (_ data: T?, _ error: Error?) -> Void)
//}
//
//public class Networking: NetworkingProtocol {
//
//    public let apiManager: APIManager
//    
//    public init(apiManager: APIManager) {
//        self.apiManager = apiManager
//    }
//    
//    public func execute<T>(_ endpoint: EndPointType, parameters: [String: Any]? = nil, completion: @escaping (T?, Error?) -> Void) where T : Decodable {
//        guard let urlRequest = apiManager.getRequest(type: endpoint, parameters: parameters) else {
//            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            
//            guard let data = data else {
//                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
//                return
//            }
//            
//            do {
//                let decodedData = try JSONDecoder().decode(T.self, from: data)
//                completion(decodedData, nil)
//            } catch let decodingError {
//                completion(nil, decodingError)
//            }
//        }
//        
//        task.resume()
//    }
//}
