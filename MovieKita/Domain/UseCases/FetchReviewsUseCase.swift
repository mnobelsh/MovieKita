//
//  FetchReviewsUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import Foundation

public struct FetchReviewsUseCaseRequestValue {
    var movieId: String
}

protocol FetchReviewsUseCase {
    func execute(requestValue: FetchReviewsUseCaseRequestValue, completion: @escaping (Result<[Review],Error>) -> Void)
}

public final class DefaultFetchReviewsUseCase: FetchReviewsUseCase {

    private var reviewsEndpoint = APIEndpoint.reviews
    
    func execute(requestValue: FetchReviewsUseCaseRequestValue, completion: @escaping (Result<[Review], Error>) -> Void) {
        let endPoint = APIEndpoint.defaultEndPoint+requestValue.movieId+self.reviewsEndpoint
        DispatchQueue.global(qos: .background).async {
            NetworkManager.shared.fetch(DecodableReviewList.self, urlSource: endPoint) { result in
                switch result {
                    case .success(let list):
                        var reviews = [Review]()
                        list.results.forEach { decodableReview in
                            reviews.append(
                                Review(
                                    id: decodableReview.id,
                                    author: decodableReview.author,
                                    authorUsername: decodableReview.author_details.username,
                                    rating: decodableReview.author_details.rating,
                                    content: decodableReview.content,
                                    createdAt: decodableReview.created_at)
                            )
                        }
                        completion(.success(reviews))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
}

// MARK: - Private Functions
extension DefaultFetchReviewsUseCase{
    
    
}
