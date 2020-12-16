//
//  MovieListCollectionViewCell.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = UUID().uuidString
    
    // MARK: - UI Components
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .moviePosterPlaceholder
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.setRoundedCorners([.allCorner], withRadius: 5)
        return imageView
    }()
    private lazy var movieTitleLabel = CustomLabel("Movie Title", for: .heading3)
    private lazy var releaseDateLabel = CustomLabel("Release Date", for: .heading4)
    private lazy var overviewTitleLabel = CustomLabel("Overview", for: .heading4)
    private lazy var overviewLabel: CustomLabel = CustomLabel("Movie Overview Description", for: .body2)
    
    
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
        self.backgroundColor = .cardBackgroundColor
        self.setRoundedCorners([.allCorner], withRadius: 15)
        
        
        self.addSubview(self.movieImageView)
        self.addSubview(self.movieTitleLabel)
        self.addSubview(self.releaseDateLabel)
        self.addSubview(self.overviewTitleLabel)
        self.addSubview(self.overviewLabel)
        
        NSLayoutConstraint.activate([
            self.movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.movieImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.movieImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            self.movieImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3),
            
            self.movieTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.movieTitleLabel.leadingAnchor.constraint(equalTo: self.movieImageView.trailingAnchor, constant: 15),
            self.movieTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.movieTitleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12),
            
            self.releaseDateLabel.topAnchor.constraint(equalTo: self.movieTitleLabel.bottomAnchor, constant: 5),
            self.releaseDateLabel.leadingAnchor.constraint(equalTo: self.movieImageView.trailingAnchor, constant: 15),
            self.releaseDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.releaseDateLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1),
            
            self.overviewTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.releaseDateLabel.bottomAnchor, constant: 5),
            self.overviewTitleLabel.bottomAnchor.constraint(equalTo: self.overviewLabel.topAnchor),
            self.overviewTitleLabel.leadingAnchor.constraint(equalTo: self.movieImageView.trailingAnchor, constant: 15),
            self.overviewTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            self.overviewLabel.leadingAnchor.constraint(equalTo: self.movieImageView.trailingAnchor, constant: 15),
            self.overviewLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            self.overviewLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            self.overviewLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
        ])
    }
    
    public func fill(with movie: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.movieTitleLabel.text = movie.title
            self.releaseDateLabel.text = "Release: \(movie.release_date)"
            if movie.overview.count > 175 {
                self.overviewLabel.text = "\(NSString(string: movie.overview).substring(to: 175))..."
            } else {
                self.overviewLabel.text = movie.overview
            }
            if let posterData = movie.posterData, let posterImage = UIImage(data: posterData) {
                self.movieImageView.image = posterImage
            }
        }
    }
}

extension MovieListCollectionViewCell {
    
}
