//
//  AppFont.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI
import UIKit

enum AppFont {
    private static let regularName = "ProductSans-Regular"
    private static let boldName = "ProductSans-Bold"
    private static let isAvailable = UIFont(name: regularName, size: 12) != nil

    static func regular(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        font(regularName, size: size, weight: .regular, style: style)
    }

    static func bold(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        font(boldName, size: size, weight: .bold, style: style)
    }

    private static func font(_ name: String, size: CGFloat, weight: Font.Weight, style: Font.TextStyle) -> Font {
        guard isAvailable else {
            return .system(size: UIFontMetrics.default.scaledValue(for: size), weight: weight)
        }
        return .custom(name, size: size, relativeTo: style)
    }
}
