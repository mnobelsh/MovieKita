//
//  MovieDetailViewModel.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation
import Snail

struct MovieDetailViewModelRequestValue {
    var movie: Movie
}

protocol MovieDetailViewModelOutput {
    var movie: Variable<Movie?> { get }
    var isFavorited: Variable<Bool> { get }
    var reviews: Variable<[Review]> { get }
}

protocol MovieDetailViewModelInput {
    func didPop(_ completion: (()->Void)?)
    func didSelectFavoriteMovie()
    func viewDidLoad()
}

protocol MovieDetailViewModel: MovieDetailViewModelInput, MovieDetailViewModelOutput {}

final class DefaultMovieDetailViewModel: MovieDetailViewModel {
    
    // MARK: - Properties
    private var coordinator: AppFlowCoordinator
    private let fetchReviewsUseCase: FetchReviewsUseCase
    private let saveMovieToFavoriteListUseCase: SaveMovieToFavoriteListUseCase
    private let removeMovieFromFavoriteListUseCase: RemoveMovieFromFavoriteListUseCase
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Output Properties
    let movie: Variable<Movie?> = .init(nil)
    let reviews: Variable<[Review]> = .init([])
    let isFavorited: Variable<Bool> = .init(false)
    
    // MARK: - Initializers
    init(
        coordinator: AppFlowCoordinator,
        requestValue: MovieDetailViewModelRequestValue,
        fetchReviewsUseCase: FetchReviewsUseCase,
        saveMovieToFavoriteListUseCase: SaveMovieToFavoriteListUseCase,
        removeMovieFromFavoriteListUseCase: RemoveMovieFromFavoriteListUseCase
    ) {
        self.coordinator = coordinator
        self.movie.value = requestValue.movie
        self.fetchReviewsUseCase = fetchReviewsUseCase
        self.saveMovieToFavoriteListUseCase = saveMovieToFavoriteListUseCase
        self.removeMovieFromFavoriteListUseCase = removeMovieFromFavoriteListUseCase
    }

}

// MARK: - Input Functions
extension DefaultMovieDetailViewModel {
    
    func didPop(_ completion: (() -> Void)?) {
        self.coordinator.pop(completion: completion)
    }
    
    func didSelectFavoriteMovie() {
        if let id = self.movie.value?.id {
            let idString = String(id)
            self.isFavorited.value ?
                self.removeMovieFromFavoriteListUseCase
                .execute(
                    .init(movieId: idString),
                    completion: nil
                )
                :
                self.saveMovieToFavoriteListUseCase
                .execute(
                    .init(movieId: idString),
                    completion: nil
                )
            self.validateIfMovieIsFavorited(String(id))
        }
    }
    
    func viewDidLoad() {
        if let movie = self.movie.value {
            self.validateIfMovieIsFavorited(String(movie.id))
            self.fetchReviewsUseCase.execute(requestValue: .init(movieId: String(movie.id))) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let reviews):
                        self.reviews.value = reviews
                        break
                    case .failure(_):
                        break
                }
            }
        }
    }
    
}

// MARK: - Private Functions
extension DefaultMovieDetailViewModel {
    
    private func validateIfMovieIsFavorited(_ movieId: String) {
        if let favoriteMovieIds = self.userDefaults.array(forKey: UserDefaultStorage.favoriteListKey) as? [String] {
            self.isFavorited.value = favoriteMovieIds.contains(movieId)
        }
    }
    
}
