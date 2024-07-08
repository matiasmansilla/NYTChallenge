//
//  ChipCollectionViewCell.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit

class ChipCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChipCollectionViewCell"
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with text: String, isSelected: Bool) {
        titleLabel.text = text
        if isSelected {
            titleLabel.backgroundColor = UIColor(named: "chipColor")
            titleLabel.textColor = .black
            contentView.layer.borderWidth = 0
        } else {
            titleLabel.backgroundColor = .white
            titleLabel.textColor = UIColor(named: "chipColor")
            contentView.layer.borderColor = UIColor(named: "chipColor")?.cgColor
            contentView.layer.borderWidth = 1
        }
    }
}
