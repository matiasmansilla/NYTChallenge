//
//  ArticlesWireframe.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit

class ArticlesWireframe {
    
    static func instantiate() -> UIViewController {
        let view =  ArticlesViewController()
        let presenter: ArticlesPresenterProtocol = ArticlesPresenter(view: view)
        view.presenter = presenter
        return view
    }
}

