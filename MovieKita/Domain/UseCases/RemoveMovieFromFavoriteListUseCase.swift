//
//  RemoveMovieFromFavoriteListUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 15/12/20.
//

import Foundation

import Foundation

public struct RemoveMovieFromFavoriteListUseCaseRequestValue {
    var movieId: String
}

protocol RemoveMovieFromFavoriteListUseCase {
    func execute(_ requestValue: SaveMovieToFavoriteListUseCaseRequestValue, completion: (()->Void)?)
}

public final class DefaultRemoveMovieFromFavoriteListUseCase: RemoveMovieFromFavoriteListUseCase {
    
    private let userDefaults = UserDefaults.standard
    
    func execute(_ requestValue: SaveMovieToFavoriteListUseCaseRequestValue, completion: (()->Void)?) {
        let movieId = requestValue.movieId
        if let favoritedList = self.userDefaults.array(forKey: UserDefaultStorage.favoriteListKey) as? [String],
           favoritedList.contains(movieId) {
            let updatedFavoriteList = favoritedList.filter({$0 != movieId})
            userDefaults.setValue(updatedFavoriteList, forKey: UserDefaultStorage.favoriteListKey)
        }
        completion?()
    }
    
}

// MARK: - Private Functions
extension DefaultRemoveMovieFromFavoriteListUseCase {}
