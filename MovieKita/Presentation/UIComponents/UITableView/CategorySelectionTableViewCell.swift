//
//  CategorySelectionTableViewCell.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import UIKit

class CategorySelectionTableViewCell: UITableViewCell {

    static let identifier = UUID().uuidString
    
    private lazy var categoryTitleLabel = CustomLabel("Category Title", for: .heading2)
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .cardBackgroundColor
        view.setRoundedCorners([.allCorner], withRadius: 0.5)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(self.separatorView)
        self.addSubview(self.categoryTitleLabel)
        self.setRoundedCorners([.allCorner], withRadius: 10)
        NSLayoutConstraint.activate([
            self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.separatorView.heightAnchor.constraint(equalToConstant: 1),
            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.categoryTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.categoryTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.categoryTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.categoryTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func fill(with category: FetchMovieListUseCaseRequestValue.MovieListCategory, selected: Bool) {
        self.backgroundColor = selected ? .cardBackgroundColor : .clear
        self.categoryTitleLabel.text = category.rawValue
    }
    
}
