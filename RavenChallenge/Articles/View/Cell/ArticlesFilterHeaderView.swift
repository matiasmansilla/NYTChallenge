//
//  ArticlesFilterHeaderView.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import UIKit

protocol ArticlesFilterHeaderViewDelegate: AnyObject {
    func didSelectArticleType(_ type: String)
    func didSelectPeriod(_ period: Int)
}

class ArticlesFilterHeaderView: UIView {
    // MARK: - Properties
    weak var delegate: ArticlesFilterHeaderViewDelegate?
    
    private let articleTypes = ["emailed", "shared", "viewed"]
    private let periods = [1, 7, 30]
    private var selectedArticleTypeIndex = 0
    private var selectedPeriodIndex = 0
    
    // MARK: - UI Components
    private lazy var articleTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChipCollectionViewCell.self, forCellWithReuseIdentifier: ChipCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var periodCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChipCollectionViewCell.self, forCellWithReuseIdentifier: ChipCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        addSubview(articleTypeCollectionView)
        addSubview(periodCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            articleTypeCollectionView.topAnchor.constraint(equalTo: topAnchor),
            articleTypeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            articleTypeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            articleTypeCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            periodCollectionView.topAnchor.constraint(equalTo: articleTypeCollectionView.bottomAnchor),
            periodCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            periodCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            periodCollectionView.heightAnchor.constraint(equalToConstant: 50),
            periodCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(selectedArticleType: String, selectedPeriod: Int) {
        selectedArticleTypeIndex = articleTypes.firstIndex(of: selectedArticleType) ?? 0
        selectedPeriodIndex = periods.firstIndex(of: selectedPeriod) ?? 0
        articleTypeCollectionView.reloadData()
        periodCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ArticlesFilterHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == articleTypeCollectionView ? articleTypes.count : periods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipCollectionViewCell.identifier, for: indexPath) as? ChipCollectionViewCell else {
            return UICollectionViewCell()
        }

        if collectionView == articleTypeCollectionView {
            cell.configure(with: articleTypes[indexPath.item], isSelected: indexPath.item == selectedArticleTypeIndex)
        } else {
            cell.configure(with: "\(periods[indexPath.item])", isSelected: indexPath.item == selectedPeriodIndex)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == articleTypeCollectionView {
            selectedArticleTypeIndex = indexPath.item
            delegate?.didSelectArticleType(articleTypes[indexPath.item])
            collectionView.reloadData()
        } else {
            selectedPeriodIndex = indexPath.item
            delegate?.didSelectPeriod(periods[indexPath.item])
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ArticlesFilterHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
}
