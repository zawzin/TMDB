//
//  PopularMovieCache.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import RealmSwift

class PopularMovieCache: Object {
    
    @Persisted var adult: Bool?
    @Persisted var backdropPath: String?
    @Persisted var genreIds = List<Int>()
    @Persisted var id: Int = 0
    @Persisted var originalLanguage: String?
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var popularity: Double?
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var title: String?
    @Persisted var video: Bool?
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Double?
    
    @Persisted var isFavourite: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func toMovie() -> Movie {
        let movie = Movie()
        movie.adult = self.adult
        movie.backdropPath = self.backdropPath
        movie.genreIds = Array(self.genreIds)
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
