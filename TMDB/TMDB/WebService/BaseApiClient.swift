//
//  BaseApiClient.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import Alamofire
import RxSwift

class BaseApiClient {
    
    func requestApiWithoutHeaders<T>(
        route: ApiRoute,
        method: HTTPMethod,
        params: Parameters,
        value: T.Type,
        encoding: ParameterEncoding = URLEncoding.default
    ) -> Observable<T>  where T : Codable {
        
        return Observable<T>.create { (observer) -> Disposable in
            
            let request =  AF.request( route.url() , method: method, parameters: params, encoding: encoding ,  headers : [:])
                .responseJSON{ response in
                                        
                    switch response.result {
                        
                    case .success:
                        
                        if  200 ... 299 ~= response.response?.statusCode ?? 500   {
                            
                            if let data = response.data {
                                
                                do {
                                    let jsonDecoder = JSONDecoder()
                                    let decoded = try jsonDecoder.decode(T.self, from: data)
                                    
                                    observer.onNext(decoded)
                                    observer.onCompleted()
                                    
                                } catch {
                                    observer.onError(NSError(domain: Constants.ErrorMessage.ERROR_MSG_JSON_PARSE, code: -1, userInfo: nil))
                                }
                                
                            } else {
                                observer.onError(NSError(domain: Constants.ErrorMessage.SERVER_ERROR, code: -1, userInfo: nil))
                            }
                            
                        } else {
                            
                            observer.onError(NSError(domain: Constants.ErrorMessage.SERVER_ERROR, code: -1, userInfo: nil))
                            
                        }
                        
                    case .failure(let error):
                        
                        observer.onError(error)
                    }
            }
            
            return Disposables.create(with: {
                request.cancel()
            })
            
        }
        
    }
}
