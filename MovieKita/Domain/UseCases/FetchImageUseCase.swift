//
//  FetchMoviePosterUseCase.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 13/12/20.
//

import Foundation

public struct FetchImageUseCaseRequestValue {
    var posterPath: String
}

protocol FetchImageUseCase {
    func execute(requestValue: FetchImageUseCaseRequestValue, completion: @escaping (Result<Data,Error>) -> Void)
}

public final class DefaultFetchImageUseCase: FetchImageUseCase {

    private var endPoint = APIEndpoint.imageEndPoint
    
    func execute(requestValue: FetchImageUseCaseRequestValue, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { 
            let imageEndpoint = self.endPoint+requestValue.posterPath
            NetworkManager.shared.fetchImage(urlSource: imageEndpoint) { result in
                completion(result)
            }
        }
    }
    
}

// MARK: - Private Functions
extension DefaultFetchImageUseCase {
    
    
}
