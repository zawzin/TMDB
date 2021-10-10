//
//  BaseViewModel.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation
import RxSwift
import RxRelay

class BaseViewModel {
    
    public var isLoadingObs:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    public var _errorObs:BehaviorRelay<String?> = BehaviorRelay(value: nil)
}
