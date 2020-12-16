//
//  EmptyReviewCollectionViewCell.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import UIKit

class EmptyReviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = UUID().uuidString
    
    private lazy var emptyCellMessageLabel = CustomLabel("No reviews yet for this movie.", for: .heading3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        self.backgroundColor = .cardBackgroundColor
        self.setRoundedCorners([.allCorner], withRadius: 10)
        
        self.emptyCellMessageLabel.textAlignment = .center
        self.addSubview(self.emptyCellMessageLabel)
        NSLayoutConstraint.activate([
            self.emptyCellMessageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.emptyCellMessageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.emptyCellMessageLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.emptyCellMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
}
