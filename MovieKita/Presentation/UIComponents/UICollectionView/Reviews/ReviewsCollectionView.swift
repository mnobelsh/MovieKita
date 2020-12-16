//
//  ReviewsCollectionView.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import UIKit

class ReviewsCollectionView: UICollectionView {

    init() {
        super.init(frame: .infinite, collectionViewLayout: ReviewsCollectionView.makeCollectionViewLayout())
        self.register(
            ReviewCollectionViewCell.self,
            forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier
        )
        self.register(
            EmptyReviewCollectionViewCell.self,
            forCellWithReuseIdentifier: EmptyReviewCollectionViewCell.identifier
        )
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension ReviewsCollectionView {
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
    }
    
    static func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
}
