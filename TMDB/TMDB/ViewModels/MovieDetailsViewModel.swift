//
//  MovieDetailsViewModel.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 10/10/2021.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    func tappedFavourite(data: Movie)
}

class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    private let realmHelper = RealmHelper.shared

    func tappedFavourite(data: Movie) {
        
        data.isFavourite.toggle()
        self.realmHelper.saveUpcomingMovie(data: data.toUpcomingMovieCache())
        self.realmHelper.savePopularMovie(data: data.toPopularMovieCache())
    }
}
