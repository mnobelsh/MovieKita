//
//  Review.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation

struct DecodableReviewList: Decodable {
    var results: [DecodableReview]
}

struct DecodableReview: Decodable {
    var id: String
    var author: String
    var author_details: DecodableAuthorDetails
    var content: String
    var created_at: String
    var updated_at: String
}

struct DecodableAuthorDetails: Decodable {
    var name: String
    var username: String
    var rating: Float
}
