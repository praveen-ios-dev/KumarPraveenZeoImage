//
//  NetworkService.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import Foundation

/// Protocol defining the contract for fetching images from the network.

protocol NetworkServiceProtocol {
    func fetchImages(query: String, page: Int, perPage: Int, completion: @escaping (Result<PexelsResponseModel, NetworkError>) -> Void)
}

/// A singleton service responsible for making network requests to the Pexels API.
class NetworkService : NetworkServiceProtocol{
    public static let shared = NetworkService()
    private init(){}
    
    /// Fetches image results from the Pexels API using query, page, and per-page values.
    func fetchImages(query: String, page: Int, perPage: Int = 40, completion: @escaping (Result<PexelsResponseModel, NetworkError>) -> Void) {
        guard let percentageEncodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.invalidURL))
            return
        }
        guard let url = URL(string: "https://api.pexels.com/v1/search?query=\(percentageEncodingQuery)&per_page=\(perPage)&page=\(page)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(AppConstant.apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                completion(.failure(.noData))
                return
            }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode(PexelsResponseModel.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }.resume()
    }
}

