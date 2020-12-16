//
//  Movie.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import Foundation

struct Movie: Identifiable, Hashable {
    var id: Int
    var title: String
    var overview: String
    var posterData: Data?
    var release_date: String
}
