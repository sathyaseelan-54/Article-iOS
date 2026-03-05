//
//  ApiError.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import Foundation
import Alamofire

struct NetworkError : Error {
    let initialError : AFError
}

enum ApiError : LocalizedError {
    case invalidResponse
    case invalidURL
    case decondingError
    case noInternet
    case unKnown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .invalidURL:
            return "The URL is invalid."
        case .decondingError:
            return "There was a problem decoding the data."
        case .unKnown(let error):
            return error.localizedDescription
        case .noInternet:
            return "Network connection lost. Please try again later."
        }
    }
}


