//
//  NetworkManager.swift
//  MovieKita
//
//  Created by Muhammad Nobel Shidqi on 12/12/20.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private struct HTTPMethod {
        static let get = "GET"
        static let post = "POST"
    }
    
    func fetch<T: Decodable>(_ object: T.Type, urlSource: String, completion: @escaping(Result<T,Error>) -> Void) {
        
        if let urlString = urlSource.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else  {
                    if let data = data {
                        self.decode(object.self, data: data) { result in
                            switch result {
                                case .success(let decoded):
                                    completion(.success(decoded))
                                case .failure(let error):
                                    completion(.failure(error))
                            }
                        }
                    }
                }
            }
            .resume()
            
        }
    
    }
    
    func fetchImage(urlSource: String, completion: @escaping (Result<Data,Error>) -> Void) {
        if let urlString = urlSource.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                } else  {
                    if let data = data {
                        completion(.success(data))
                    }
                }
            }
            .resume()
        }
    }
    
    private func decode<T: Decodable>(_ type: T.Type,data: Data, completion: @escaping(Result<T,Error>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(type.self, from: data)
            completion(.success(decoded))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    
}
