//
//  MovieListViewModel.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation
import Snail

struct MovieListViewModelRequestValue {}

protocol MovieListViewModelOutput {
    var movieList: Variable<[Movie]> { get }
    var fetchingState: Variable<Bool> { get }
}

protocol MovieListViewModelInput {
    func didSelectMovieListCategory(_ movieListCategory: FetchMovieListUseCaseRequestValue.MovieListCategory, completion: (()->Void)?)
    func didFetchMoviePoster(_ posterPath: String, completion: @escaping (Result<Data,Error>)->Void )
    func didSelectMovie(_ movie: Movie)
    func didSelectFavoriteBarButtonItem()
    func viewDidLoad()
}

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {}

final class DefaultMovieListViewModel: MovieListViewModel {
    
    let coordinator: AppFlowCoordinator
    
    // MARK: - Output Properties
    let movieList: Variable<[Movie]> = .init([])
    let fetchingState: Variable<Bool> = .init(false)
    
    // MARK: - Private Properties
    private let fetchMovieListUseCase: FetchMovieListUseCase
    private let fetchImageUseCase: FetchImageUseCase
    private let movieListCategory: Variable<FetchMovieListUseCaseRequestValue.MovieListCategory> = .init(.nowPlaying)
    
    // MARK: - Initializers
    init(
        coordinator: AppFlowCoordinator,
        fetchMovieListUseCase: FetchMovieListUseCase,
        fetchImageUseCase: FetchImageUseCase
    ) {
        self.coordinator = coordinator
        self.fetchMovieListUseCase = fetchMovieListUseCase
        self.fetchImageUseCase = fetchImageUseCase
    }
    
}

// MARK: - Input Functions
extension DefaultMovieListViewModel {
    
    func viewDidLoad() {
        self.movieListCategory.asObservable().subscribe(queue: .main) { [weak self] category in
            guard let self = self else { return }
            self.observeMovieListCategory(category)
        }
    }
    
    func didFetchMoviePoster(_ posterPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        self.fetchImageUseCase.execute(requestValue: .init(posterPath: posterPath)) { result in
            completion(result)
        }
    }
    
    func didSelectMovie(_ movie: Movie) {
        self.coordinator.start(.movieDetail(movie))
    }
    
    func didSelectFavoriteBarButtonItem() {
        self.coordinator.start(.favoriteList)
    }
    

    func didSelectMovieListCategory(_ movieListCategory: FetchMovieListUseCaseRequestValue.MovieListCategory, completion: (() -> Void)?) {
        if self.movieListCategory.value != movieListCategory {
            self.movieListCategory.value = movieListCategory
        }
        completion?()
    }
    

    
}

// MARK: - Private Functions
extension DefaultMovieListViewModel {
    
    private func observeMovieListCategory(_ category: FetchMovieListUseCaseRequestValue.MovieListCategory) {
        self.fetchingState.value = true
        self.fetchMovieListUseCase.execute(requestValue: .init(movieListType: category), completion: { result in
            switch result {
                case .success(let movies):
                    self.movieList.value = movies
                    self.fetchingState.value = false
                    break
                case .failure(_):
                    break
            }
        })
    }
    
}
