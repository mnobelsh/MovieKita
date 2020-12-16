//
//  HeaderCollectionReusableView.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import UIKit

protocol HeaderCollectionReusableViewDelegate {
    func headerCollectionReusableView(_ headerCollectionReusableView: HeaderCollectionReusableView, didTap changeCategoryButton: UIButton)
}

class HeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier: String = UUID().uuidString
    static let elementKind: String = UUID().uuidString
    
    var delegate: HeaderCollectionReusableViewDelegate?
    
    // MARK: - UI Components
    private lazy var sectionTitleLabel = CustomLabel("Now Playing", for: .heading2)
    private lazy var changeCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Category", for: .normal)
        button.addTarget(self, action: #selector(self.onChangeCategoryButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Function
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(self.sectionTitleLabel)
        self.addSubview(self.changeCategoryButton)
        NSLayoutConstraint.activate([
            self.changeCategoryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            self.changeCategoryButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.sectionTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            self.sectionTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.sectionTitleLabel.trailingAnchor.constraint(equalTo: self.changeCategoryButton.leadingAnchor, constant: -15)
        ])
    }
    
    public func fill(with category: FetchMovieListUseCaseRequestValue.MovieListCategory) {
        self.sectionTitleLabel.text = category.rawValue
    }
    
}

// MARK: - @objc Functions
extension HeaderCollectionReusableView {
    
    @objc private func onChangeCategoryButtonDidTap(_ sender: UIButton) {
        delegate?.headerCollectionReusableView(self, didTap: self.changeCategoryButton)
    }
    
}
