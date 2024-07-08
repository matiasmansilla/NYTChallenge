//
//  OfflineArticlesWireframe.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 07/07/2024.
//

import UIKit

class OfflineArticlesWireframe {
    
    static func instantiate() -> UIViewController {
        let view =  OfflineArticlesViewController()
        let presenter = OfflineArticlesPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
