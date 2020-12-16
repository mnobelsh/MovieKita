//
//  AppFlowCoordinator.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import UIKit

class AppFlowCoordinator {
    
    // MARK: - Properties
    private var window: UIWindow
    private var navigationController: UINavigationController
    
    enum Instructor {
        case movieList,
             favoriteList,
             movieDetail(_ movie: Movie)
    }
    
    // MARK: - Initializer
    init(
        window: UIWindow,
        navigationController: UINavigationController
    ) {
        self.window = window
        self.navigationController = navigationController
    }

}

// MARK: - Public Functions
extension AppFlowCoordinator {
    
    func start(_ instructor: Instructor) {
        switch instructor {
        case .movieDetail(let movie):
                let viewModel = DefaultMovieDetailViewModel(
                    coordinator: self,
                    requestValue: .init(movie: movie),
                    fetchReviewsUseCase: DefaultFetchReviewsUseCase(),
                    saveMovieToFavoriteListUseCase: DefaultSaveMovieToFavoriteListUseCase(),
                    removeMovieFromFavoriteListUseCase: DefaultRemoveMovieFromFavoriteListUseCase()
                )
                let viewController = MovieDetailViewController(viewModel: viewModel)
                self.navigationController.pushViewController(viewController, animated: true)
                break
            case .favoriteList:
                let viewModel = DefaultFavoriteListViewModel(
                    coordinator: self,
                    fetchFavoriteListUseCase: DefaultFetchFavoriteListUseCase()
                )
                let viewController = FavoriteListViewController(viewModel: viewModel)
                self.navigationController.pushViewController(viewController, animated: true)
                break
            case .movieList:
                self.window.makeKeyAndVisible()
                self.navigationController.viewControllers = [
                    MovieListViewController(
                        viewModel: DefaultMovieListViewModel(
                            coordinator: self,
                            fetchMovieListUseCase: DefaultFetchMovieListUseCase(),
                            fetchImageUseCase: DefaultFetchImageUseCase()
                        )
                    )
                ]
                self.window.rootViewController = self.navigationController
                break
        }
    }
    
    func pop(completion: (()->Void)? = nil) {
        self.navigationController.popViewController(animated: true)
        completion?()
    }
    
}
