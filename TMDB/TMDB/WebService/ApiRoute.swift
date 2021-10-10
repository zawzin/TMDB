//
//  ApiRoute.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation

enum ApiRoute {
    
    case upcoming
    case popular
    
    var path: String {
        switch self {
        case .upcoming : return "upcoming"
        case .popular : return "popular"
        }
    }
    
    func url() -> String {
        return "\(Constants.Api.baseURL)\(path)"
    }
}
