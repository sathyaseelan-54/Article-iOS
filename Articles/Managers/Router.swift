//
//  Router.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import Foundation
import Alamofire


enum Router {
    case getArticle
    
    var path : String {
        switch self {
        case .getArticle:
            return "https://mocki.io/v1/50422b19-547f-41c0-b623-e82d886ad264"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .getArticle:
            return .get
        }
    }
}
