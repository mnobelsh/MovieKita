//
//  FetchFavoriteListUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import Foundation

public struct FetchFavoriteListUseCaseRequestValue {}

protocol FetchFavoriteListUseCase {
    func execute(completion: @escaping (Result<[Movie],Error>) -> Void)
}

public final class DefaultFetchFavoriteListUseCase: FetchFavoriteListUseCase {
    
    let userDefaults = UserDefaults.standard
    private let fetchMovieUseCase = DefaultFetchMovieUseCase()
    
    func execute(completion: @escaping (Result<[Movie],Error>) -> Void) {
        if let movieIdList = self.userDefaults.array(forKey: UserDefaultStorage.favoriteListKey) as? [String] {
            var movies = [Movie]()
            movieIdList.forEach { movieId in
                self.fetchMovieUseCase.execute(movieId: movieId) { result in
                    switch result {
                    case .success(let movie):
                        movies.append(movie)
                        completion(.success(movies))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        completion(.success([]))
    }
    
}

// MARK: - Private Functions
extension DefaultFetchFavoriteListUseCase {}
