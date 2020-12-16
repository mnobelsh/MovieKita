//
//  FavoriteListViewController.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class FavoriteListViewController: UIViewController {

    // MARK: - Properties
    var viewModel: FavoriteListViewModel!
    
    private lazy var favoriteMovies = [Movie]()
    private lazy var isFetching = false
    
    // MARK: - UI Components
    private lazy var favoriteMoviesCollectionView = MovieListCollectionView()
    
    // MARK: - Initializer
    convenience init(viewModel: FavoriteListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(to: self.viewModel)
        self.setupViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
        self.setupViewWillAppear()
    }


}

// MARK: - Private Functions
extension FavoriteListViewController {
    
    private func bind(to viewModel: FavoriteListViewModel) {
        
        viewModel.favoriteMovies.asObservable().subscribe(queue: .main) { [weak self] movies in
            guard let self = self else { return }
            self.observeFavoriteListViewModel(movies)
        }
        
        viewModel.isFetching.asObservable().subscribe(queue: .main) { [weak self] isFetching in
            guard let self = self else { return }
            self.isFetching = isFetching
        }
        
    }
    
    private func observeFavoriteListViewModel(_ movies: [Movie]) {
        self.favoriteMovies = movies
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.favoriteMoviesCollectionView.reloadData()
        }
    }
    
    private func setupViewDidLoad() {
        self.view.backgroundColor = .backgroundColor
        
        self.favoriteMoviesCollectionView.dataSource = self
        self.favoriteMoviesCollectionView.delegate = self
        self.view.addSubview(self.favoriteMoviesCollectionView)
        NSLayoutConstraint.activate([
            self.favoriteMoviesCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.favoriteMoviesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.favoriteMoviesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.favoriteMoviesCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupViewWillAppear() {
        self.setupNavbar()
    }
    
    private func setupNavbar() {
        self.navigationItem.title = Constants.screenTitle
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .barTintColor
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
}

// MARK: - UICollectionView Delegate, DataSource & DelegateFlowLayout
extension FavoriteListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFetching {
            return 5
        }
        return self.favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isFetching {
            if let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier, for: indexPath) as? LoadingCollectionViewCell {
                return loadingCell
            }
        } else {
            if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as? MovieListCollectionViewCell {
                let movie = self.favoriteMovies[indexPath.row]
                movieCell.fill(with: movie)
                return movieCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: self.view.frame.width - (Constants.edgeInset*2),
            height: self.view.frame.height * 0.25
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: Constants.edgeInset,
            left: Constants.edgeInset,
            bottom: Constants.edgeInset,
            right: Constants.edgeInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isFetching, !self.favoriteMovies.isEmpty {
            let selectedMovie = self.favoriteMovies[indexPath.row]
            self.viewModel.didSelectMovie(selectedMovie)
        }
    }

}

// MARK: - Constants
extension FavoriteListViewController {
    
    struct Constants {
        static var screenTitle: String {
            return "My Favorites"
        }
        
        static var edgeInset: CGFloat {
            return 25
        }
    }
    
}
