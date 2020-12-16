//
//  UIImage.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import UIKit

extension UIImage {
    
    static var moviePosterPlaceholder: UIImage {
        return UIImage(named: ImageName.moviePoster)!
    }
    
    static var defaultFavoriteIcon: UIImage {
        return UIImage(systemName: "heart.fill")!.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    static var selectedFavoriteIcon: UIImage {
        return UIImage(systemName: "heart.fill")!.withTintColor(.favoriteIconColor, renderingMode: .alwaysOriginal)
    }
    
    static var unselectedFavoriteIcon: UIImage {
        return UIImage(systemName: "heart.fill")!.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    }
    
}
