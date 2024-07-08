//
//  ArticleTableViewCell.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ArticleTableViewCell"
    
    // MARK: - UI Components
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func buildViewHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bylineLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 75),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bylineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bylineLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            bylineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: bylineLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        bylineLabel.text = "\(article.byline)"
        dateLabel.text = formatDate(article.publishedDate)
        
        if let media = article.media.first,
           let metadata = media.mediaMetadata.first(where: { $0.format == "Standard Thumbnail" }) {
            thumbnailImageView.loadImageUsingCache(withUrl: metadata.url, placeholder: UIImage(named: "placeholder"))
        } else {
            thumbnailImageView.image = UIImage(named: "placeholder")
        }
    }
    
    func configureOffline(with article: FavoriteArticle) {
        titleLabel.text = article.title
        bylineLabel.text = "\(article.byline ?? "")"
        dateLabel.text = formatDate(article.publishedDate ?? "")
        if let thumbnailData = article.thumbnailData {
            thumbnailImageView.image = UIImage(data: thumbnailData)
        } else {
            thumbnailImageView.image = UIImage(named: "placeholder")
        }
    }
    
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
