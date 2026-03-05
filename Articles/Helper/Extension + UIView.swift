//
//  Extension + UIView.swift
//  Articles
//
//  Created by Sathya on 03/03/26.
//

import Foundation
import UIKit

extension UIView {

    /// UIView Set Corener Radius
    /// - Parameters:
    ///   - radius: CGFloat
    ///   - borderColor: UIColor
    ///   - borderWidth: CGFloat
    func setCornerRadius(radius: CGFloat, borderColor: UIColor = #colorLiteral(red: 0.5019607843, green: 0.5843137255, blue: 0.7176470588, alpha: 1), borderWidth: CGFloat = 0.0) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
