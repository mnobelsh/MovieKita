//
//  LoadingCollectionViewCell.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = UUID().uuidString
    
    // MARK: - UI Components
    private lazy var loadingImageView: UIView = LoadingCollectionViewCell.makeLoadingViewComponent()
    private lazy var loadingTitleView: UIView = LoadingCollectionViewCell.makeLoadingViewComponent()
    private lazy var loadingDescriptionView: UIStackView = {
        var arrangedSubviews = [UIView]()
        for _ in 0..<5 {
            arrangedSubviews.append(LoadingCollectionViewCell.makeLoadingViewComponent())
        }
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func setupUI() {
        self.backgroundColor = .loadingBackgroundColor
        self.setRoundedCorners([.allCorner], withRadius: 15)
        
        
        self.addSubview(self.loadingImageView)
        self.addSubview(self.loadingTitleView)
        self.addSubview(self.loadingDescriptionView)
        
        NSLayoutConstraint.activate([
            self.loadingImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.loadingImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.loadingImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            self.loadingImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            
            self.loadingTitleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.loadingTitleView.leadingAnchor.constraint(equalTo: self.loadingImageView.trailingAnchor, constant: 10),
            self.loadingTitleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            self.loadingTitleView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12),
            
            self.loadingDescriptionView.leadingAnchor.constraint(equalTo: self.loadingImageView.trailingAnchor, constant: 10),
            self.loadingDescriptionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            self.loadingDescriptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.loadingDescriptionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
        ])
    }
    
}

// MARK: - Static Functions
extension LoadingCollectionViewCell {
    
    static func makeLoadingViewComponent() -> UIView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .loadingComponentsColor
        view.setRoundedCorners([.allCorner], withRadius: 5)
        return view
    }
    
}
