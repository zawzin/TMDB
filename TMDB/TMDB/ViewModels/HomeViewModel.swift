//
//  HomeViewModel.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelProtocol {
    func refreshData()
    func loadUpcomingMovies(isLoadMore: Bool)
    func loadPopularMovies(isLoadMore: Bool)
    func tappedFavourite(data: Movie)
}

class HomeViewModel: BaseViewModel, HomeViewModelProtocol {
    
    public var upcomingMoviesObs:BehaviorRelay<[Movie]> = BehaviorRelay(value: [])
    public var popularMoviesObs:BehaviorRelay<[Movie]> = BehaviorRelay(value: [])

    let service = MovieService.shared
    private let bag = DisposeBag()
    private let realmHelper = RealmHelper.shared
    
    private var pageNoUpcoming: Int = 1
    private var pageNoPopular: Int = 1
    
    private var upcomingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    
    func refreshData() {
        self.pageNoUpcoming = 1
        self.pageNoPopular = 1
        
        self.loadCaches()
        
        self.loadUpcomingMovies()
        self.loadPopularMovies()
    }
    
    private func loadCaches() {
        realmHelper.getUpcomingMovies()
            .map { $0.map { $0.toMovie() } }
            .bind(to: self.upcomingMoviesObs)
            .disposed(by: self.bag)
        
        realmHelper.getPopularMovies()
            .map { $0.map { $0.toMovie() } }
            .bind(to: self.popularMoviesObs)
            .disposed(by: self.bag)
    }
    
    func loadPopularMovies(isLoadMore: Bool = false) {
        
        if !isLoadMore {
            self.isLoadingObs.accept(true)
        }
        
        let pageNo = isLoadMore ? (self.pageNoPopular + 1) : 1
        
        let cacheObs = realmHelper.getPopularMovies()
        let dataObs = service.requestPopularMovies(page: pageNo)
        
        Observable.combineLatest(cacheObs, dataObs)
            .subscribe { caches, response in
                
                self.isLoadingObs.accept(false)
                
                if let results = response.results {
                    if isLoadMore && !results.isEmpty {
                        self.pageNoPopular = pageNo
                        self.popularMovies.append(contentsOf: results)
                    } else if !isLoadMore {
                        self.popularMovies = results
                    }
                    
                    var popularCaches: [PopularMovieCache] = []
                    self.popularMovies.forEach { popular in
                        popular.isFavourite = caches.first(where: { $0.id == popular.id } )?.isFavourite ?? false
                        
                        popularCaches.append(popular.toPopularMovieCache())
                    }
                    
                    self.realmHelper.savePopularMovies(data: popularCaches) { error in
                        debugPrint(error)
                    }
                }
                
            } onError: { error in
                self._errorObs.accept(error.localizedDescription)
            }.disposed(by: self.bag)
    }
    
    func loadUpcomingMovies(isLoadMore: Bool = false) {
        
        if !isLoadMore {
            self.isLoadingObs.accept(true)
        }
        
        let pageNo = isLoadMore ? (self.pageNoUpcoming + 1) : 1
        
        let cacheObs = realmHelper.getUpcomingMovies()
        let dataObs = service.requestUpcomigMovies(page: pageNo)
        
        Observable.combineLatest(cacheObs, dataObs)
            .subscribe { caches, response in
                
                self.isLoadingObs.accept(false)
                
                if let results = response.results {
                    if isLoadMore && !results.isEmpty {
                        self.pageNoUpcoming = pageNo
                        self.upcomingMovies.append(contentsOf: results)
                    } else if !isLoadMore {
                        self.upcomingMovies = results
                    }
                    
                    var upcomingCaches: [UpcomingMovieCache] = []
                    self.upcomingMovies.forEach { upcoming in
                        upcoming.isFavourite = caches.first(where: { $0.id == upcoming.id } )?.isFavourite ?? false
                        
                        upcomingCaches.append(upcoming.toUpcomingMovieCache())
                    }
                    
                    self.realmHelper.saveUpcomingMovies(data: upcomingCaches) { error in
                        debugPrint(error)
                    }
                }
                
            } onError: { error in
                self._errorObs.accept(error.localizedDescription)
            }.disposed(by: self.bag)
    }
    
    func tappedFavourite(data: Movie) {
        
        data.isFavourite.toggle()
        self.realmHelper.saveUpcomingMovie(data: data.toUpcomingMovieCache())
        self.realmHelper.savePopularMovie(data: data.toPopularMovieCache())
    }
}
