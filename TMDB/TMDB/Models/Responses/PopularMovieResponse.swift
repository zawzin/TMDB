//
//  PopularMovieResponse.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import RxCocoa

struct PopularMovieResponse: Codable {
    
    var page: Int
    var results: [Movie]?
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
