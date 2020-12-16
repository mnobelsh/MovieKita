//
//  APIEndpoint.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation

struct APIEndpoint {
    
    static let defaultEndPoint = "https://api.themoviedb.org/3/movie/"
    static let imageEndPoint = "https://image.tmdb.org/t/p/w500/"
    static let APIKey = "77f55ddcb2bae10b35a03d5106a78e7e"
    
    static let popularMovies = "\(APIEndpoint.defaultEndPoint)popular?api_key=\(APIEndpoint.APIKey)&language=en-US&page=1"
    static let topRatedMovies = "\(APIEndpoint.defaultEndPoint)top_rated?api_key=\(APIEndpoint.APIKey)&language=en-US&page=1"
    static let nowPlayingMovies = "\(APIEndpoint.defaultEndPoint)now_playing?api_key=\(APIEndpoint.APIKey)&language=en-US&page=1"
    static let upcomingMovies = "\(APIEndpoint.defaultEndPoint)upcoming?api_key=\(APIEndpoint.APIKey)&language=en-US&page=1"
    static let movieById = "?api_key=77f55ddcb2bae10b35a03d5106a78e7e&language=en-US"
    static let reviews = "/reviews?api_key=\(APIEndpoint.APIKey)&language=en-US&page=1"
}
