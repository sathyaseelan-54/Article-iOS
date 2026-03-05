//
//  ReachabilityService.swift
//  Articles
//
//  Created by Sathya on 04/03/26.
//

import Foundation
import Reachability

class ReachabilityService {
    static let shared = ReachabilityService()
    private let reachability = try! Reachability()

    var isReachable: Bool { reachability.connection != .unavailable }

    func start(_ onChange: @escaping (Bool) -> Void) {
        reachability.whenReachable = { _ in onChange(true) }
        reachability.whenUnreachable = { _ in onChange(false) }
        try? reachability.startNotifier()
    }

    func stop() {
        reachability.stopNotifier()
    }
}
