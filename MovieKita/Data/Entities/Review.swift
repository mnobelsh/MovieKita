//
//  Review.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import Foundation


struct Review: Identifiable, Hashable {
    var id: String
    var author: String
    var authorUsername: String
    var rating: Float
    var content: String
    var createdAt: String
}
