//
//  MockNetworkService.swift
//  KumarPraveenZeoImageTests
//
//  Created by Praveen on 10/04/25.
//

import Foundation
@testable import KumarPraveenZeoImage


/// A mock implementation of `NetworkServiceProtocol` used for unit testing.
class MockNetworkService: NetworkServiceProtocol {
    
    /// Mock photos to return on a successful fetch.
    var mockPhotos: [PexelsPhoto] = []
    
    /// Flag to simulate a failure in the API call.
    var shouldFail: Bool = false

    
    /// Simulates fetching images either successfully or with an error based on `shouldFail`.
    func fetchImages(query: String, page: Int,perPage: Int, completion: @escaping (Result<PexelsResponseModel, NetworkError>) -> Void) {
        if shouldFail {
            completion(.failure(.decodingFailed))
        } else {
            let response = loadJSON("Nature", as: PexelsResponseModel.self)
            completion(.success(response))
        }
    }
    
    /// Loads and decodes a local JSON file from the bundle into the given model type.
    func loadJSON<T: Decodable>(_ filename: String, as type: T.Type) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            fatalError(String(format: AppConstant.couldNotFindJsonMsg, filename))
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fatalError(String(format: AppConstant.failtoDecode, "\(filename).json", "\(error)"))
        }
    }
    
}
