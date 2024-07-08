//
//  ArticlesPresenter.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import Foundation

protocol ArticlesPresenterProtocol: AnyObject {
    init(view: ArticlesViewProtocol, articleService: ArticleServiceProtocol)
    func fetchArticles(articleType: String, period: Int)
}

class ArticlesPresenter: ArticlesPresenterProtocol {
    weak var view: ArticlesViewProtocol?
    var articleService: ArticleServiceProtocol
    
    required init(view: ArticlesViewProtocol, articleService: ArticleServiceProtocol = ArticleService()) {
        self.view = view
        self.articleService = articleService
    }
    
    func fetchArticles(articleType: String, period: Int) {
        view?.showLoading()
        
        articleService.fetchArticles(articleType: articleType, period: period) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let response):
                if response.results.isEmpty {
                    self.view?.showEmptyState()
                } else {
                    self.view?.showArticles(response.results)
                }
            case .failure(let error):
                if let nsError = error as NSError?, nsError.code == NSURLErrorNotConnectedToInternet {
                    self.view?.showNoInternetState()
                } else {
                    self.view?.showError(error)
                }
            }
        }
    }
}

