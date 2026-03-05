//
//  NetworkManager.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import Foundation
import Alamofire
import XCGLogger
import AlamofireNetworkActivityIndicator
import Loaf
import Network

protocol ApiClientProtocol {
    func request<T: Decodable>(
        router: Router,
        parameters: Parameters?,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

final class NetworkManager: ApiClientProtocol {
    static let shared = NetworkManager()
    
    private let logger = XCGLogger.default
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private var currentPath: NWPath?
    //    private let reachability = try? Reachability()
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentPath = path
        }
        monitor.start(queue: monitorQueue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        
        return Session(configuration: configuration)
    }()
    
    var isConnected: Bool {
        return currentPath?.status == .satisfied
    }
    
    func request<T: Decodable>(
        router: Router,
        parameters: Parameters? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        logger.info("Request URL: \(router.path)")
        logger.info("Method: \(router.method)")
        
        session.request(
            router.path,
            method: router.method,
            parameters: parameters,
            encoding: JSONEncoding.default
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            
            if let data = response.data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    let prettyData = try JSONSerialization.data(
                        withJSONObject: jsonObject,
                        options: [.prettyPrinted]
                    )
                    
                    if let prettyString = String(data: prettyData, encoding: .utf8) {
                        self.logger.info("Response:\n\(prettyString)")
                    }
                } catch {
                    self.logger.error("Failed to pretty print JSON: \(error.localizedDescription)")
                }
            }
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                
                let networkError = NetworkError(
                    initialError: error
                )
                
                completion(.failure(networkError))
            }
        }
    }
}
