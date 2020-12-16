//
//  Movie.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation

struct DecodableMovieList: Decodable {
    var results: [DecodableMovie]
}

struct DecodableMovie: Decodable {
    var id: Int
    var original_title: String
    var title: String
    var overview: String
    var poster_path: String?
    var release_date: String
}
