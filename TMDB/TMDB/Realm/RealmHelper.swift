//
//  RealmHelper.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 10/10/2021.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import Realm

class RealmHelper: BaseRealmHelper {
    
    static let shared = RealmHelper()
    
    func saveUpcomingMovie(data: UpcomingMovieCache) {
        do {
            
            if realm.isInWriteTransaction { return }
            
            try realm.write{
                realm.add(data, update: .modified)
            }
        } catch let ex {
            debugPrint(ex.localizedDescription)
        }
    }
    
    func saveUpcomingMovies(data: [UpcomingMovieCache], onError: @escaping ((String) -> Void)) {
        
        do {
            
            if realm.isInWriteTransaction { return }
            
            try realm.write{
                realm.add(data, update: .modified)
            }
            
        } catch let ex {
            onError(ex.localizedDescription)
        }
    }
    
    func getUpcomingMovies() -> Observable<[UpcomingMovieCache]> {
        
        let obs = Observable.array(from: realm.objects(UpcomingMovieCache.self))

        return obs
    }
    
    func savePopularMovie(data: PopularMovieCache) {
        do {
            
            if realm.isInWriteTransaction { return }
            
            try realm.write{
                realm.add(data, update: .modified)
            }
        } catch let ex {
            debugPrint(ex.localizedDescription)
        }
    }
    
    func savePopularMovies(data: [PopularMovieCache], onError: @escaping ((String) -> Void)) {
        do {
            
            if realm.isInWriteTransaction { return }
            
            try realm.write{
                realm.add(data, update: .modified)
            }
            
        } catch let ex {
            onError(ex.localizedDescription)
        }
    }
    
    func getPopularMovies() -> Observable<[PopularMovieCache]> {
        
        let obs = Observable.array(from: realm.objects(PopularMovieCache.self))

        return obs
    }
}
