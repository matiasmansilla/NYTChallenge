//
//  ArticleDetailWireframe.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import Foundation

import UIKit

class ArticleDetailWireframe {
    static func instantiate(with article: ArticleDetailModel) -> UIViewController {
        let view = ArticleDetailViewController()
        let presenter: ArticleDetailPresenterProtocol = ArticleDetailPresenter(view: view, article: article)
        view.presenter = presenter
        return view
    }
}
