//
//  AppColor.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

enum AppColor {
    static let primary = Color(hex: 0x80BA27)
    static let secondary = Color(hex: 0x00513A)
    static let expense = Color(hex: 0xE5484D)
    static let background = Color("Background")
    static let surface = Color("Surface")
    static let border = Color("Border")

    static let heroGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}

extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255)
    }
}
