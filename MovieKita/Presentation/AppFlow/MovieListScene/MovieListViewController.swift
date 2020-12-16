//
//  MovieListViewController.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class MovieListViewController: UIViewController {

    // MARK: - Properties
    var viewModel: MovieListViewModel!
    
    private var movies: [Movie] = []
    private var isFetching: Bool = false
    private var selectedCategory: FetchMovieListUseCaseRequestValue.MovieListCategory = .nowPlaying
    
    // MARK: - UI Components
    private lazy var movieListCollectionView = MovieListCollectionView()
    private lazy var categorySelectionView = CategorySelectionView()
    
    // MARK: - Initializer
    convenience init(viewModel: MovieListViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.viewDidLoad()
        self.setupViewDidLoad()
        self.bind(to: self.viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }

}

// MARK: - Private Functions
extension MovieListViewController {
    
    private func bind(to viewModel: MovieListViewModel) {
        
        viewModel.movieList.asObservable().subscribe(queue: .main) { [weak self] movies in
            guard let self = self else { return }
            self.observeMovieListViewModel(movies)
        }
        
        viewModel.fetchingState.asObservable().subscribe(queue: .main) { [weak self] loadingState in
            guard let self = self else { return }
            self.observeFetchingStateViewModel(loadingState)
        }

    }
    
    private func observeMovieListViewModel(_ movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            self.movieListCollectionView.reloadData()
        }
    }
    
    private func observeFetchingStateViewModel(_ isLoading: Bool) {
        self.isFetching = isLoading
    }
    
    private func setupViewDidLoad() {
        self.view.backgroundColor = .backgroundColor
        self.setupNavigationBar()
        
        if let superview = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            self.categorySelectionView.frame = superview.bounds
            superview.addSubview(self.categorySelectionView)
            self.categorySelectionView.alpha = 0
            NSLayoutConstraint.activate([
                self.categorySelectionView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.categorySelectionView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                self.categorySelectionView.topAnchor.constraint(equalTo: superview.topAnchor),
                self.categorySelectionView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            ])
        }
        
        self.categorySelectionView.delegate = self
        self.categorySelectionView.setUITableViewDataSource(self)
        self.categorySelectionView.setUITableViewDelegate(self)

        self.movieListCollectionView.delegate = self
        self.movieListCollectionView.dataSource = self
        self.view.addSubview(self.movieListCollectionView)
        NSLayoutConstraint.activate([
            self.movieListCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.movieListCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.movieListCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.movieListCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = Constants.screenTitle
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .barTintColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.heading3
        ]
        let rightBarButtonImage: UIImage = .defaultFavoriteIcon
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: rightBarButtonImage,
            style: .plain,
            target: self,
            action: #selector(self.onRightBarButtonItemDidTap(_:))
        )
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
}

// MARK: - UICollectionView Delegate, DataSource, DelegateFlowLayout
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isFetching, !self.movies.isEmpty {
            let selectedMovie = self.movies[indexPath.row]
            self.viewModel.didSelectMovie(selectedMovie)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isFetching {
            return 5
        }
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isFetching {
            if let loadingCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LoadingCollectionViewCell.identifier,
                for: indexPath) as? LoadingCollectionViewCell
            {
                return loadingCell
            }
        } else {
            if let movieListCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieListCollectionViewCell.identifier,
                for: indexPath) as? MovieListCollectionViewCell
            {
                let movie = self.movies[indexPath.row]
                movieListCell.fill(with: movie)
                return movieListCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderCollectionReusableView.elementKind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView {
            headerView.fill(with: self.selectedCategory)
            headerView.delegate = self
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(
            width: self.view.frame.width - (Constants.edgeInset*2),
            height: self.view.frame.height*0.25
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: 10,
            left: Constants.edgeInset,
            bottom: Constants.edgeInset,
            right: Constants.edgeInset
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 80)
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FetchMovieListUseCaseRequestValue.MovieListCategory.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CategorySelectionTableViewCell.identifier, for: indexPath) as? CategorySelectionTableViewCell {
            let category = FetchMovieListUseCaseRequestValue.MovieListCategory.allCases[indexPath.row]
            cell.fill(
                with: category,
                selected: category == self.selectedCategory
            )
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height * 0.25
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        let category = FetchMovieListUseCaseRequestValue.MovieListCategory.allCases[indexPath.row]
        self.viewModel.didSelectMovieListCategory(category) {
            DispatchQueue.main.async {
                self.selectedCategory = category
                self.categorySelectionView.hide()
                self.categorySelectionView.reloadTableView()
            }
        }
    }
    
}


// MARK: - @objc Functions
extension MovieListViewController {
    
    @objc private func onRightBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.didSelectFavoriteBarButtonItem()
    }
    
}

// MARK: - HeaderCollectionReusableViewDelegate
extension MovieListViewController: HeaderCollectionReusableViewDelegate {
    
    func headerCollectionReusableView(
        _ headerCollectionReusableView: HeaderCollectionReusableView,
        didTap changeCategoryButton: UIButton
    ) {
        self.categorySelectionView.show()
    }
    
}

// MARK: - CategorySelectionViewDelegate
extension MovieListViewController: CategorySelectionViewDelegate {
    
    func categorySelectionView(didTap superview: UIView) {
        self.categorySelectionView.hide()
    }
    
}

// MARK: - Constants
extension MovieListViewController {
    
    private struct Constants {
        static let screenTitle: String = "MovieKita"
        static let edgeInset: CGFloat = 25
    }
    
    private struct MovieDetailButtonConstants {
        static let title: String = "Upcoming"
    }
    
    private struct FavoriteListButtonConstants {
        static let title: String = "Top Rated"
    }
    
}
