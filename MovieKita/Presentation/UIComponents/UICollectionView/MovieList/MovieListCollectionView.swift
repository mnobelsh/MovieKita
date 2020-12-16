//
//  MovieListCollectionView.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class MovieListCollectionView: UICollectionView {

    init() {
        super.init(frame: .infinite, collectionViewLayout: MovieListCollectionView.makeCollectionViewLayout())
        self.register(
            LoadingCollectionViewCell.self,
            forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier
        )
        self.register(
            MovieListCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier
        )
        self.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: HeaderCollectionReusableView.elementKind,
            withReuseIdentifier: HeaderCollectionReusableView.identifier
        )
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension MovieListCollectionView {
    
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    static func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
}
