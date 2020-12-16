//
//  FavoriteListViewModel.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation
import Snail

struct FavoriteListViewModelRequestValue {}

protocol FavoriteListViewModelOutput {
    var favoriteMovies: Variable<[Movie]> { get }
    var isFetching: Variable<Bool> { get }
}

protocol FavoriteListViewModelInput {
    func viewWillAppear()
    func didSelectMovie(_ movie: Movie)
}

protocol FavoriteListViewModel: FavoriteListViewModelInput, FavoriteListViewModelOutput {}

final class DefaultFavoriteListViewModel: FavoriteListViewModel {

    // MARK: - Properties
    private var coordinator: AppFlowCoordinator
    private let fetchFavoriteListUseCase: FetchFavoriteListUseCase
    
    // MARK: - Ouput Properties
    let favoriteMovies: Variable<[Movie]> = .init([])
    let isFetching: Variable<Bool> = .init(false)
    
    init(
        coordinator: AppFlowCoordinator,
        fetchFavoriteListUseCase: FetchFavoriteListUseCase
    ) {
        self.coordinator = coordinator
        self.fetchFavoriteListUseCase = fetchFavoriteListUseCase
    }
    
}

// MARK: - Input Functions
extension DefaultFavoriteListViewModel {
    
    func didSelectMovie(_ movie: Movie) {
        self.coordinator.start(.movieDetail(movie))
    }
    
    func viewWillAppear() {
        self.fetchFavoriteList()
    }
    
}


// MARK: - Private Functions
extension DefaultFavoriteListViewModel {
    
    private func fetchFavoriteList() {
        self.isFetching.value = true
        self.fetchFavoriteListUseCase.execute { result in
            switch result {
                case .success(let movies):
                    self.favoriteMovies.value = movies
                    self.isFetching.value = false
                    break
                case .failure(_):
                    self.isFetching.value = false
                    break
            }
        }
    }
    
}
