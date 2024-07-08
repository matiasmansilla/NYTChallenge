//
//  ArticleService.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 07/07/2024.
//

import Foundation

protocol ArticleServiceProtocol {
    func fetchArticles(articleType: String, period: Int, completion: @escaping (Result<ArticlesResponse, Error>) -> Void)

}

class ArticleService: BaseService, ArticleServiceProtocol {
    func fetchArticles(articleType: String, period: Int, completion: @escaping (Result<ArticlesResponse, Error>) -> Void) {
        
        let endpoint = ArticlesEndpoint.mostPopularArticles(type: articleType, period: period)
        let parameters = ["api-key": apiKey]
        networking.execute(endpoint, parameters: parameters, completion: completion)
    }
}
