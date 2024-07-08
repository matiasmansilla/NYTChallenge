//
//  OfflineArticlesViewController.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit
import CoreData

protocol OfflineArticlesViewProtocol: AnyObject {
    func showOfflineArticles(_ articles: [FavoriteArticle])
    func showError(_ error: Error)
}

class OfflineArticlesViewController: UIViewController {
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Properties
    var presenter: OfflineArticlesPresenterProtocol!
    private var articles: [FavoriteArticle] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        buildViewHierarchy()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchOfflineArticles()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Bookmarks"
    }

    // MARK: - Private Methods
    private func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension OfflineArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        let article = articles[indexPath.row]
        cell.configureOffline(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = articles[indexPath.row]
            presenter.deleteOfflineArticle(article)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let articleDetailModel = ArticleDetailModel.transform(entity: articles[indexPath.row]) {
            let detailViewController = ArticleDetailWireframe.instantiate(with: articleDetailModel)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

// MARK: - OfflineArticlesViewProtocol
extension OfflineArticlesViewController: OfflineArticlesViewProtocol {
    func showOfflineArticles(_ articles: [FavoriteArticle]) {
        self.articles = articles
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print("Error fetching offline articles: \(error)")
        // Optionally, show an alert or other UI to inform the user
    }
}

