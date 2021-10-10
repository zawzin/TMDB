//
//  UpcomingMovieResponse.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation

struct UpcomingMovieResponse: Codable {
    var dates: MovieDates?
    var page: Int
    var results: [Movie]?
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDates: Codable {
    var maximum: String?
    var minimum: String?
}
