//
//  OfflineArticlesPresenter.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import CoreData

protocol OfflineArticlesPresenterProtocol: AnyObject {
    init(view: OfflineArticlesViewProtocol)
    func fetchOfflineArticles()
    func deleteOfflineArticle(_ article: FavoriteArticle)
}

class OfflineArticlesPresenter: OfflineArticlesPresenterProtocol {
    weak var view: OfflineArticlesViewProtocol?
    
    required init(view: OfflineArticlesViewProtocol) {
        self.view = view
    }
    
    func fetchOfflineArticles() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        
        do {
            let articles = try context.fetch(fetchRequest)
            view?.showOfflineArticles(articles)
        } catch let error {
            view?.showError(error)
        }
    }
    
    func deleteOfflineArticle(_ article: FavoriteArticle) {
        let context = CoreDataStack.shared.context
        context.delete(article)
        
        do {
            try context.save()
            fetchOfflineArticles()
        } catch let error {
            view?.showError(error)
        }
    }
}

