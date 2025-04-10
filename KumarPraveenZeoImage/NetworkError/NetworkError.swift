//
//  NetworkError.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import Foundation

/// Represents possible networking errors.
enum NetworkError: Error{
    case invalidURL
    case noData
    case decodingFailed
}
