//
//  FetchMoviesUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation

public struct FetchMovieListUseCaseRequestValue {
    enum MovieListCategory: String, CaseIterable {
        case popular = "Popular",
             nowPlaying = "Now Playing",
             upcoming = "Upcoming",
             topRated = "Top Rated"
    }
    var movieListType: MovieListCategory
}

protocol FetchMovieListUseCase {
    func execute(requestValue: FetchMovieListUseCaseRequestValue, completion: @escaping (Result<[Movie],Error>) -> Void)
}

public final class DefaultFetchMovieListUseCase: FetchMovieListUseCase {
    
    private var endPoint = APIEndpoint.defaultEndPoint
    private var fetchImageUseCase = DefaultFetchImageUseCase()
    
    func execute(requestValue: FetchMovieListUseCaseRequestValue, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        self.endPoint = self.getEndpoint(byRequestValue: requestValue)
        
        DispatchQueue.global(qos: .background).async { 
            NetworkManager.shared.fetch(DecodableMovieList.self, urlSource: self.endPoint) { result in
                switch result {
                    case .success(let list):
                        self.fetchMoviesPoster(list.results) { movies in
                            completion(.success(movies))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
        completion(.success([]))
    }
    
}

// MARK: - Private Functions
extension DefaultFetchMovieListUseCase {
    
    private func fetchMoviesPoster(_ decodableMovies: [DecodableMovie], completion: @escaping([Movie]) -> Void) {
        var movies = [Movie]()
        decodableMovies.forEach { decodableMovie in
            if let posterPath = decodableMovie.poster_path {
                self.fetchImageUseCase.execute(requestValue: .init(posterPath: posterPath)) { result in
                    switch result {
                        case .success(let data):
                            movies.append(
                                Movie(
                                    id: decodableMovie.id,
                                    title: decodableMovie.title,
                                    overview: decodableMovie.overview,
                                    posterData: data,
                                    release_date: decodableMovie.release_date
                                )
                            )
                            completion(movies)
                            break
                        case .failure(_):
                            completion([])
                            break
                    }
                }
            }
        }
    }
    
    private func getEndpoint(byRequestValue requestValue: FetchMovieListUseCaseRequestValue) -> String {
        switch requestValue.movieListType {
            case .nowPlaying:
                return APIEndpoint.nowPlayingMovies
            case .popular:
                return APIEndpoint.popularMovies
            case .topRated:
                return APIEndpoint.topRatedMovies
            case .upcoming:
                return APIEndpoint.upcomingMovies
        }
    }
    
}
