//
//  ArticlesPresenterTests.swift
//  RavenChallengeTests
//
//  Created by Dardo Matias Mansilla on 07/07/2024.
//

import XCTest
@testable import RavenChallenge

class ArticlesPresenterTests: XCTestCase {
    
    var presenter: ArticlesPresenter!
    var mockView: MockArticlesView!
    var mockService: MockArticleService!
    
    override func setUp() {
        super.setUp()
        mockView = MockArticlesView()
        mockService = MockArticleService()
        presenter = ArticlesPresenter(view: mockView, articleService: mockService)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() {
        let articles = [Article(uri: "uri", url: "url", id: 1, assetId: 1, source: "source", publishedDate: "2023-07-07", updated: "2023-07-07", section: "section", subsection: "subsection", nytdsection: "nytdsection", adxKeywords: "adxKeywords", column: nil, byline: "By Author", type: "type", title: "Test Article", abstract: "abstract", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], media: [], etaId: 0)]
        let articlesResponse = ArticlesResponse(status: "OK", copyright: "Copyright (c) 2024 The New York Times Company.  All Rights Reserved.", numResults: articles.count, results: articles)
        mockService.fetchArticlesResult = .success(articlesResponse)
        
        presenter.fetchArticles(articleType: "emailed", period: 1)
        
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showArticlesCalled)
        XCTAssertEqual(mockView.articles?.first?.title, articles.first?.title)
    }
    
    func testFetchArticlesEmpty() {
        let articlesResponse = ArticlesResponse(status: "OK", copyright: "Copyright (c) 2024 The New York Times Company.  All Rights Reserved.", numResults: 0, results: [])
        mockService.fetchArticlesResult = .success(articlesResponse)
        
        presenter.fetchArticles(articleType: "emailed", period: 1)
        
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showEmptyStateCalled)
    }
    
    func testFetchArticlesFailureWithInternetError() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        mockService.fetchArticlesResult = .failure(error)
        
        presenter.fetchArticles(articleType: "emailed", period: 1)
        
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showNoInternetStateCalled)
    }
    
    func testFetchArticlesFailureWithOtherError() {
        let error = NSError(domain: "test", code: 123, userInfo: nil)
        mockService.fetchArticlesResult = .failure(error)
        
        presenter.fetchArticles(articleType: "emailed", period: 1)
        
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.error as NSError?, error)
    }
}

class MockArticlesView: ArticlesViewProtocol {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var showArticlesCalled = false
    var showEmptyStateCalled = false
    var showErrorCalled = false
    var showNoInternetStateCalled = false
    
    var articles: [Article]?
    var error: Error?
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func showArticles(_ articles: [Article]) {
        showArticlesCalled = true
        self.articles = articles
    }
    
    func showEmptyState() {
        showEmptyStateCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
        self.error = error
    }
    
    func showNoInternetState() {
        showNoInternetStateCalled = true
    }
}


class MockArticleService: ArticleServiceProtocol {
    var fetchArticlesResult: Result<ArticlesResponse, Error>?
    
    func fetchArticles(articleType: String, period: Int, completion: @escaping (Result<ArticlesResponse, Error>) -> Void) {
        if let result = fetchArticlesResult {
            completion(result)
        }
    }
}
