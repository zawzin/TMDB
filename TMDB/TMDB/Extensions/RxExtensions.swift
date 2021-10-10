//
//  RxExtensions.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import RxSwift
import RxRelay
extension Observable {
    
    func subscribeData<T: Any, R: Any>(errorObs:BehaviorRelay<String?>, mapper: @escaping((T) -> R)) -> PublishSubject<R>{
        
        let obs =  PublishSubject<R>()
        _ = subscribe(on: ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global())).subscribe(onNext: { data in
            
            obs.onNext(mapper(data as! T))
            
        },onError: { error in
            
            errorObs.accept((error as NSError).localizedDescription)
            
        })
        
        return obs
        
    }
    
    func subscribeDataWithError<T: Any, R: Any>(onError:@escaping((NSError) -> Void), mapper: @escaping((T) -> R)) -> PublishSubject<R>{
        
        let obs =  PublishSubject<R>()
        _ = subscribe(on: ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global())).subscribe(onNext: { data in
            
            obs.onNext(mapper(data as! T))
            
        },onError: { error in
            
            onError(error as NSError)
            
        })
        
        return obs
        
    }
    
}

extension BehaviorRelay {
    
    func observe<T:Any,R:Any>(mapper: @escaping((T) -> R)) -> BehaviorRelay<R?> {
          let obs =  BehaviorRelay<R?>(value: nil)
          
        _ = observe(on: MainScheduler.instance)
              .subscribe(onNext:{ data in
              
              obs.accept(mapper(data as! T))
              
          })
          return obs
      }
}
