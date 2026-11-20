//
//  ExpenseCategory.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

enum ExpenseCategory: String, CaseIterable, Identifiable {
    case foodAndBeverage, transportAndFuel, clothing, transactionFees

    var id: String { rawValue }

    var name: String {
        switch self {
        case .foodAndBeverage:
            "Food & Beverage"
        case .transportAndFuel:
            "Transport & Fuel"
        case .clothing:
            "Clothing"
        case .transactionFees:
            "Transaction Fees"
        }
    }

    var color: Color {
        switch self {
        case .foodAndBeverage:
            Color(hex: 0x12304F)
        case .transportAndFuel:
            Color(hex: 0x80BA27)
        case .clothing:
            Color(hex: 0x6FCDEB)
        case .transactionFees:
            Color(hex: 0xF07A45)
        }
    }

    var icon: String {
        switch self {
        case .foodAndBeverage:
            "fork.knife"
        case .transportAndFuel:
            "fuelpump.fill"
        case .clothing:
            "tshirt.fill"
        case .transactionFees:
            "arrow.left.arrow.right"
        }
    }
}
