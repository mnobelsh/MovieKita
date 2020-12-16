//
//  ReviewCollectionViewCell.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = UUID().uuidString
    
    // MARK: - UI Components
    private let reviewContentLabel = CustomLabel("Review Content", for: .body2)
    private let usernameLabel = CustomLabel("Username", for: .heading4)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Function
    public func fill(with review: Review) {
        self.reviewContentLabel.text = review.content
        self.usernameLabel.text = review.authorUsername
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        self.backgroundColor = .loadingBackgroundColor
        self.setRoundedCorners([.allCorner], withRadius: 10)
        
        self.addSubview(self.reviewContentLabel)
        self.addSubview(self.usernameLabel)
        
        NSLayoutConstraint.activate([
            self.reviewContentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.reviewContentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.reviewContentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            self.reviewContentLabel.heightAnchor.constraint(equalToConstant: self.frame.height * 0.7),
            
            self.usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.usernameLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.reviewContentLabel.topAnchor, constant: -10),
            self.usernameLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
}
