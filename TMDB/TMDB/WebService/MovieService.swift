//
//  Api.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import Alamofire
import RxSwift

protocol MovieApi {
    func requestUpcomigMovies(page: Int) -> Observable<UpcomingMovieResponse>
    func requestPopularMovies(page: Int) -> Observable<PopularMovieResponse>
}

class MovieService: BaseApiClient, MovieApi {
    
    static let shared: MovieApi = MovieService()
    
    private override init() {}
}

extension MovieService {
    
    func requestUpcomigMovies(page: Int) -> Observable<UpcomingMovieResponse> {
        
        let params = [
            "api_key" : Constants.apiKey,
            "page" : page
        ] as [String : Any]
        
        return self.requestApiWithoutHeaders(route: .upcoming, method: .get, params: params, value: UpcomingMovieResponse.self)
    }
    
    func requestPopularMovies(page: Int) -> Observable<PopularMovieResponse> {
        let params = [
            "api_key" : Constants.apiKey,
            "page" : page
        ] as [String : Any]
        
        return self.requestApiWithoutHeaders(route: .popular, method: .get, params: params, value: PopularMovieResponse.self)
    }
}
