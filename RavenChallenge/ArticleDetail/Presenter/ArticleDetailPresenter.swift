//
//  ArticleDetailPresenter.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit
import CoreData

protocol ArticleDetailPresenterProtocol: AnyObject {
    func getArticle()
    func toggleFavorite()
    func setImageData(data: Data)
}

class ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    
    func setImageData(data: Data) {
        article.thumbnailData = data
    }
    
    weak var view: ArticleDetailViewProtocol?
    private var article: ArticleDetailModel
    var isFavorite: Bool = false
    
    required init(view: ArticleDetailViewProtocol, article: ArticleDetailModel) {
        self.view = view
        self.article = article
    }
    
    func getArticle() {
        checkIfFavorite()
    }

    func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            saveArticleToFavorites()
        } else {
            removeArticleFromFavorites()
        }
        view?.updateBookmarkButton(isFavorite: isFavorite)
    }

    // MARK: - Core Data Methods
    private func saveArticleToFavorites() {
        let context = CoreDataStack.shared.context
        let favoriteArticle = FavoriteArticle(context: context)
        favoriteArticle.title = article.title
        favoriteArticle.byline = article.byline
        favoriteArticle.publishedDate = article.publishedDate
        favoriteArticle.abstract = article.abstract
        favoriteArticle.thumbnailData = article.thumbnailData
        CoreDataStack.shared.saveContext()
    }

    private func removeArticleFromFavorites() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            CoreDataStack.shared.saveContext()
        } catch let error {
            print("Failed to fetch articles: \(error)")
        }
    }
    
    private func checkIfFavorite() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favorite = results.first,
               let articleDetailModel = ArticleDetailModel.transform(entity: favorite) {
                isFavorite = true
                view?.showArticleDetail(with: articleDetailModel)
            } else {
                isFavorite = false
                view?.showArticleDetail(with: article)
            }
            view?.updateBookmarkButton(isFavorite: isFavorite)
        } catch let error {
            print("Failed to fetch articles: \(error)")
        }
    }
}
