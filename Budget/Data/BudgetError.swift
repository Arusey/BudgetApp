//
//  BudgetError.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

enum BudgetError: LocalizedError, Equatable {
    case loadFailed
    case saveFailed
    case emptyName
    case invalidAmount

    var errorDescription: String? {
        switch self {
        case .loadFailed:
            "We couldn't load your budget. Please try again"
        case .saveFailed:
            "We couldn't save your changes. Please try again"
        case .emptyName:
            "Enter an item name"
        case .invalidAmount:
            "Enter an amount greater than 0"
        }
    }
}
