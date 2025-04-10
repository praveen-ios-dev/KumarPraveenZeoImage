//
//  PexelsResponseModel.swift
//  KumarPraveenZeoImage
//
//  Created by Praveen on 10/04/25.
//

import Foundation

struct PexelsResponseModel: Codable {
    let page, perPage: Int
    let photos: [PexelsPhoto]
    
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
    }
}

// MARK: - Photo
struct PexelsPhoto: Identifiable, Codable, Equatable, Hashable {
    static func == (lhs: PexelsPhoto, rhs: PexelsPhoto) -> Bool {
        lhs.id == rhs.id
    }
    let id: Int
    let photographer: String
    let src: Src
    let alt: String
    let avgColor: String
    
    enum CodingKeys: String, CodingKey {
        case id, photographer
        case src, alt
        case avgColor = "avg_color"
    }

}

// MARK: - Src
struct Src: Codable, Hashable {
    let original: String
    
    enum CodingKeys: String, CodingKey {
        case original
    }
}
