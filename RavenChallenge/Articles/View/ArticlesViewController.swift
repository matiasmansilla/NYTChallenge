//
//  ArticlesViewController.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit

protocol ArticlesViewProtocol: AnyObject {
    func showArticles(_ articles: [Article])
    func showError(_ error: Error)
    func showLoading()
    func hideLoading()
    func showEmptyState()
    func showNoInternetState()
}

class ArticlesViewController: UIViewController {
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var stateView: StateView = {
        let stateView = StateView()
        stateView.translatesAutoresizingMaskIntoConstraints = false
        stateView.isHidden = true
        return stateView
    }()
    
    private var articlesFilterHeaderView: ArticlesFilterHeaderView?
    
    // MARK: - Properties
    var presenter: ArticlesPresenterProtocol?
    
    private var articles: [Article] = []
    private var selectedArticleType = "emailed"
    private var selectedPeriod = 1

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        buildViewHierarchy()
        setupConstraints()
        presenter?.fetchArticles(articleType: selectedArticleType, period: selectedPeriod)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Noticias"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let bookmarksButton = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: self, action: #selector(showBookmarks))
        navigationItem.rightBarButtonItem = bookmarksButton
    }

    // MARK: - Private Methods
    private func buildViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(stateView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc private func showBookmarks() {
        let offlineArticlesViewController = OfflineArticlesWireframe.instantiate()
        navigationController?.pushViewController(offlineArticlesViewController, animated: true)
        
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row]
        let detailViewController = ArticleDetailWireframe.instantiate(with: ArticleDetailModel.transform(entity: article))
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if articlesFilterHeaderView == nil {
            articlesFilterHeaderView = ArticlesFilterHeaderView()
            articlesFilterHeaderView?.delegate = self
            articlesFilterHeaderView?.configure(selectedArticleType: selectedArticleType, selectedPeriod: selectedPeriod)
        }
        return articlesFilterHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}

// MARK: - HeaderViewDelegate
extension ArticlesViewController: ArticlesFilterHeaderViewDelegate {
    func didSelectArticleType(_ type: String) {
        selectedArticleType = type
        presenter?.fetchArticles(articleType: selectedArticleType, period: selectedPeriod)
    }

    func didSelectPeriod(_ period: Int) {
        selectedPeriod = period
        presenter?.fetchArticles(articleType: selectedArticleType, period: selectedPeriod)
    }
}

// MARK: - ArticlesViewProtocol
extension ArticlesViewController: ArticlesViewProtocol {
    func showLoading() {
        setState(isHidden: false, image: "", title: "Loading...", message: "Please wait while we fetch the articles.")
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.stateView.isHidden = true
            self.tableView.isHidden = false
        }
    }
    
    func showEmptyState() {
        setState(isHidden: false, image: "doc.text.magnifyingglass", title: "No Articles", message: "There are no articles to display.")
    }
    
    func showNoInternetState() {
        setState(isHidden: false, image: "network.slash", title: "No Internet", message: "Please check your internet connection and try again.")
    }
    
    func showError(_ error: Error) {
        setState(isHidden: false, image: "exclamationmark.triangle.fill", title: "Error", message: error.localizedDescription)
    }
    
    func showArticles(_ articles: [Article]) {
        self.articles = articles
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setState(isHidden: Bool, image: String, title: String, message: String) {
        DispatchQueue.main.async {
            self.stateView.isHidden = isHidden
            self.tableView.isHidden = !isHidden
            self.stateView.configure(image: UIImage(systemName: image), title: title, message: message)
        }
    }
}
