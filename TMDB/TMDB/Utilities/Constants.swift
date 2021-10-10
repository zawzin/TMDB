//
//  Constants.swift
//  TMDB
//
//  Created by Zaw Zin Phyo on 09/10/2021.
//

import Foundation

struct Constants {
    
    static let apiKey = "fe12680f19358211acdc59a7b8cf627f"
    
    struct Api {
        static let baseURL = "https://api.themoviedb.org/3/movie/"
        static let baseImageURL = "https://image.tmdb.org/t/p/original/"
    }
    
    struct Storyboard {
        static let main = "Main"
    }
    
    struct ErrorMessage {
        static let ERROR_MSG_JSON_PARSE = "Invalid Data!"
        static let CONNECTION_ERROR = "Connection Error"
        static let SERVER_ERROR = "Server Error"
    }
}
