//
//  FetchMovieUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 14/12/20.
//

import Foundation

public struct FetchMovieUseCaseRequestValue {}

protocol FetchMovieUseCase {
    func execute(movieId: String, completion: @escaping (Result<Movie,Error>) -> Void)
}

public final class DefaultFetchMovieUseCase: FetchMovieUseCase {
    
    private var fetchImageUseCase = DefaultFetchImageUseCase()
    
    func execute(movieId: String, completion: @escaping (Result<Movie, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let endPoint = APIEndpoint.defaultEndPoint+movieId+APIEndpoint.movieById
            NetworkManager.shared.fetch(DecodableMovie.self, urlSource: endPoint) { result in
                switch result {
                    case .success(let decodableMovie):
                        self.fetchMoviesPoster(decodableMovie) { movie in
                            completion(.success(movie))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
}

// MARK: - Private Functions
extension DefaultFetchMovieUseCase {
    
    private func fetchMoviesPoster(_ decodableMovie: DecodableMovie, completion: @escaping(Movie) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let posterPath = decodableMovie.poster_path {
                self.fetchImageUseCase.execute(requestValue: .init(posterPath: posterPath)) { result in
                    switch result {
                        case .success(let posterData):
                            completion(
                                Movie(
                                    id: decodableMovie.id,
                                    title: decodableMovie.title,
                                    overview: decodableMovie.overview,
                                    posterData: posterData,
                                    release_date: decodableMovie.release_date
                                )
                            )
                            break
                        case .failure(_):
                            break
                    }
                }
            }
        }
    }
    
}
