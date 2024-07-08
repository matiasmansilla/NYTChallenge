//
//  ArticleDetailViewController.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit
import CoreData

protocol ArticleDetailViewProtocol: AnyObject {
    func showArticleDetail(with article: ArticleDetailModel)
    func showError(_ error: Error)
    func updateBookmarkButton(isFavorite: Bool)
}

class ArticleDetailViewController: UIViewController {
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private lazy var abstractLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Properties
    var presenter: ArticleDetailPresenterProtocol?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildViewHierarchy()
        setupConstraints()
        setupNavigationBar()
        presenter?.getArticle()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Detalle del Artículo"
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem = bookmarkButton
    }

    @objc private func toggleFavorite() {
        presenter?.toggleFavorite()
    }

    // MARK: - Private Methods
    private func buildViewHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bylineLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(abstractLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bylineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bylineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bylineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: bylineLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            abstractLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            abstractLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            abstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            abstractLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - ArticleDetailViewProtocol
extension ArticleDetailViewController: ArticleDetailViewProtocol {
    func showArticleDetail(with article: ArticleDetailModel) {
        let placeHolderImage = UIImage(named: "placeholder")
        titleLabel.text = article.title
        bylineLabel.text = article.byline
        dateLabel.text = formatDate(article.publishedDate)
        abstractLabel.text = article.abstract
        
        if let thumbnail = article.thumbnail {
            imageView.loadImageUsingCache(withUrl: thumbnail, placeholder: placeHolderImage) { [weak self] data in
                guard let self, let data else { return }
                self.presenter?.setImageData(data: data)
            }
        } else if let thumbnailData = article.thumbnailData {
            imageView.image = UIImage(data: thumbnailData)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    func showError(_ error: Error) {
        print("Error: \(error)")
    }

    func updateBookmarkButton(isFavorite: Bool) {
        let imageName = isFavorite ? "bookmark.fill" : "bookmark"
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: imageName)
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString else { return "date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
