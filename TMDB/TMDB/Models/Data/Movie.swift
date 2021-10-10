//
//  Movie.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import RealmSwift

class Movie: Codable {
    
    var adult: Bool?
    var backdropPath: String?
    var genreIds: [Int]?
    var id: Int = 0
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var popularity: Double?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Double?
    var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func getFullbackdropPath() -> String {
        return "\(Constants.Api.baseImageURL)\(backdropPath ?? "")"
    }
    
    func getFullposterPath() -> String {
        return "\(Constants.Api.baseImageURL)\(posterPath ?? "")"
    }
    
    func toPopularMovieCache() -> PopularMovieCache {
        let movie = PopularMovieCache()
        movie.adult = self.adult
        movie.backdropPath = self.backdropPath
        movie.genreIds.append(objectsIn: self.genreIds ?? [])
        movie.id = self.id
        movie.originalLanguage = self.originalLanguage
        movie.originalTitle = self.title
        movie.overview = self.overview
        movie.popularity = self.popularity
        movie.posterPath = self.posterPath
        movie.releaseDate = self.releaseDate
        movie.title = self.title
        movie.video = self.video
        movie.voteAverage = self.voteAverage
        movie.voteCount = self.voteCount
        movie.isFavourite = self.isFavourite
        
        return movie
    }
    
    func toUpcomingMovieCache() -> UpcomingMovieCache {
        let movie = UpcomingMovieCache()
        movie.adult = self.adult
        movie.backdropPath = self.backdropPath
        movie.genreIds.append(objectsIn: self.genreIds ?? [])
        movie.id = self.id
        movie.originalLanguage = self.originalLanguage
        movie.originalTitle = self.title
        movie.overview = self.overview
        movie.popularity = self.popularity
        movie.posterPath = self.posterPath
        movie.releaseDate = self.releaseDate
        movie.title = self.title
        movie.video = self.video
        movie.voteAverage = self.voteAverage
        movie.voteCount = self.voteCount
        movie.isFavourite = self.isFavourite
        
        return movie
    }
}
