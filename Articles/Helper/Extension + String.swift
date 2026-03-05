//
//  Extension + String.swift
//  Articles
//
//  Created by Sathya on 04/03/26.
//

import Foundation
import UIKit

extension String {
    
    static func formatPublishedAtString(_ dateString: String) -> String {
        let iso = ISO8601DateFormatter()
        // Try common options, including fractional seconds which many APIs use.
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = iso.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }

        // If parsing with fractional seconds failed, try without.
        let isoNoFrac = ISO8601DateFormatter()
        isoNoFrac.formatOptions = [.withInternetDateTime]
        if let date = isoNoFrac.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.locale = .current
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }

        // Fallback: return the raw string
        return dateString
    }

    /// Convenience instance method equivalent to `String.formatPublishedAtString(self)`.
    func formattedAsPublishedAt() -> String {
        return String.formatPublishedAtString(self)
    }
}
