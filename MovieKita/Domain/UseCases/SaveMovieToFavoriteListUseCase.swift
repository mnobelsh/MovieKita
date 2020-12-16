//
//  SaveMovieToFavoriteListUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import Foundation

public struct SaveMovieToFavoriteListUseCaseRequestValue {
    var movieId: String
}

protocol SaveMovieToFavoriteListUseCase {
    func execute(_ requestValue: SaveMovieToFavoriteListUseCaseRequestValue, completion: (()->Void)?)
}

public final class DefaultSaveMovieToFavoriteListUseCase: SaveMovieToFavoriteListUseCase {
    
    private let userDefaults = UserDefaults.standard
    
    func execute(_ requestValue: SaveMovieToFavoriteListUseCaseRequestValue, completion: (()->Void)?) {
        if let favoritedList = self.userDefaults.array(forKey: UserDefaultStorage.favoriteListKey) as? [String] {
            var updatedFavoritedList = favoritedList
            if !updatedFavoritedList.contains(requestValue.movieId) {
                updatedFavoritedList.append(requestValue.movieId)
                self.userDefaults.setValue(updatedFavoritedList, forKey: UserDefaultStorage.favoriteListKey)
            }
        } else {
            var favoritedList = [String]()
            favoritedList.append(requestValue.movieId)
            self.userDefaults.setValue(favoritedList, forKey: UserDefaultStorage.favoriteListKey)
        }
        completion?()
    }
    
}

// MARK: - Private Functions
extension DefaultSaveMovieToFavoriteListUseCase {}
