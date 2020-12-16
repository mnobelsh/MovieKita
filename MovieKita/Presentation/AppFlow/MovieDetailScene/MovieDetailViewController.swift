//
//  MovieDetailViewController.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: MovieDetailViewModel!
    
    private var movieReviews: [Review] = [] {
        didSet {
            if !movieReviews.isEmpty {
                self.reviewsCollectionViewHeightAnchor.constant = (ReviewsCollectionViewConstants.cellHeight * CGFloat(self.movieReviews.count)) + 60
            }
        }
    }
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    private lazy var movieTitleLabel: CustomLabel = {
        let label = CustomLabel("Movie Title", for: .heading1)
        label.textColor = .white
        return label
    }()
    private lazy var reviewsTitleLabel = CustomLabel("Reviews", for: .heading2)
    private lazy var releaseDateTitleLabel: CustomLabel = {
        let label = CustomLabel("Release: n/a", for: .heading3)
        label.textColor = .backgroundColor
        return label
    }()
    private lazy var overviewDescriptionLabel = CustomLabel("Overview Description", for: .body1)
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView(image: .moviePosterPlaceholder)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        let blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        imageView.addSubview(blurView)
        blurView.addSubview(self.releaseDateTitleLabel)
        blurView.addSubview(self.movieTitleLabel)
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: imageView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            self.releaseDateTitleLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: Constants.edgeInset),
            self.releaseDateTitleLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -Constants.edgeInset),
            self.releaseDateTitleLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -15),
            
            self.movieTitleLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: Constants.edgeInset),
            self.movieTitleLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -Constants.edgeInset),
            self.movieTitleLabel.bottomAnchor.constraint(equalTo: self.releaseDateTitleLabel.topAnchor, constant: -10),
            
        ])
        
        return imageView
    }()
    private lazy var overviewContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        
        let overviewTitleLabel = CustomLabel("Overview", for: .heading2)
        
        containerView.addSubview(self.overviewDescriptionLabel)
        containerView.addSubview(overviewTitleLabel)
        
        NSLayoutConstraint.activate([
            self.overviewDescriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.overviewDescriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.overviewDescriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            overviewTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            overviewTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            overviewTitleLabel.bottomAnchor.constraint(equalTo: self.overviewDescriptionLabel.topAnchor, constant: -15)
        ])
        
        
        return containerView
    }()
    private lazy var reviewsCollectionView = ReviewsCollectionView()
    
    private lazy var reviewsCollectionViewHeightAnchor = self.reviewsCollectionView.heightAnchor.constraint(equalToConstant: ReviewsCollectionViewConstants.cellHeight)
   
    
    // MARK: - Initializer
    convenience init(viewModel: MovieDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
        self.bind(to: self.viewModel)
        self.setupViewDidLoad()
    }
    

}

// MARK: - Private Functions
extension MovieDetailViewController {
    
    private func bind(to viewModel: MovieDetailViewModel) {
        
        viewModel.movie.asObservable().subscribe(queue: .main) { [weak self] movie in
            guard let self = self else { return }
            self.observeMovieViewModel(movie)
        }
        
        viewModel.reviews.asObservable().subscribe(queue: .main) { [weak self] reviews in
            guard let self = self else { return }
            self.observeReviewsViewModel(reviews)
        }
        
        viewModel.isFavorited.asObservable().subscribe(queue: .main) { [weak self] isFavorited in
            guard let self = self else { return }
            self.observeIsFavoritedMovieViewModel(isFavorited)
        }
        
    }
    
    private func observeMovieViewModel(_ movie: Movie?) {
        if let movie = movie {
            if let posterData = movie.posterData {
                self.posterImageView.image = UIImage(data: posterData)
            }
            self.movieTitleLabel.text = movie.title
            self.releaseDateTitleLabel.text = "Release: \(movie.release_date)"
            self.overviewDescriptionLabel.text = movie.overview
        }
    }
    
    private func observeReviewsViewModel(_ reviews: [Review]) {
        self.movieReviews = reviews
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.reviewsCollectionView.reloadData()
        }
    }
    
    private func observeIsFavoritedMovieViewModel(_ isFavorited: Bool) {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.image = isFavorited ? .selectedFavoriteIcon : .unselectedFavoriteIcon
        }
    }
    
    private func setupViewDidLoad() {
        self.view.backgroundColor = .backgroundColor
        self.setupNavigationBar()
        self.reviewsCollectionView.delegate = self
        self.reviewsCollectionView.dataSource = self
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.posterImageView)
        self.scrollView.addSubview(self.overviewContainerView)
        self.scrollView.addSubview(self.reviewsTitleLabel)
        self.scrollView.addSubview(self.reviewsCollectionView)
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.posterImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.posterImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.posterImageView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor, multiplier: 0.35),
            
            self.overviewContainerView.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 30),
            self.overviewContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.edgeInset),
            self.overviewContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.edgeInset),
            self.overviewContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            self.reviewsTitleLabel.topAnchor.constraint(equalTo: self.overviewContainerView.bottomAnchor, constant: 30),
            self.reviewsTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.edgeInset),
            self.reviewsTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.edgeInset),
            
            self.reviewsCollectionView.topAnchor.constraint(equalTo: self.reviewsTitleLabel.bottomAnchor, constant: 15),
            self.reviewsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.reviewsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.reviewsCollectionViewHeightAnchor,
            self.reviewsCollectionView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Constants.edgeInset),
        ])
    }
    
    private func setupNavigationBar() {
        if let navbar = self.navigationController?.navigationBar {
            navbar.isTranslucent = true
            navbar.backgroundColor = .clear
            navbar.setBackgroundImage(UIImage(), for: .default)
            navbar.shadowImage = UIImage()
            navbar.tintColor = .barTintColor
        }
        let rightBarButtonImage: UIImage = .unselectedFavoriteIcon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightBarButtonImage,
            style: .plain,
            target: self,
            action: #selector(self.onRightBarButtonItemDidTap(_:))
        )
    }
    
}

// MARK: - UICollectionView Delegate, DataSource, DelegateFlowLayout
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.movieReviews.isEmpty {
            return 1
        }
        return self.movieReviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.movieReviews.isEmpty {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyReviewCollectionViewCell.identifier, for: indexPath) as? EmptyReviewCollectionViewCell {
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as? ReviewCollectionViewCell {
                let review = self.movieReviews[indexPath.row]
                cell.fill(with: review)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: ReviewsCollectionViewConstants.cellWidth,
            height: ReviewsCollectionViewConstants.cellHeight
        )
    }
    
}

// MARK: - @objc Functions
extension MovieDetailViewController {
    
    @objc private func onRightBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        self.viewModel.didSelectFavoriteMovie()
    }
    
}

extension MovieDetailViewController {
    
    struct Constants {
        static var edgeInset: CGFloat {
            return 25
        }
    }
    
    struct ReviewsCollectionViewConstants {
        static var cellHeight: CGFloat {
            return 180
        }
        static var cellWidth: CGFloat {
            return UIScreen.main.bounds.width - (Constants.edgeInset * 2)
        }
    }
    
}
