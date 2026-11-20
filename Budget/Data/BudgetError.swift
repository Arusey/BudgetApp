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

    var errorDescription: String? {
        switch self {
        case .loadFailed:
            "We couldn't load your budget. Please try again"
        case .saveFailed:
            "We couldn't save your changes. Please try again"
        }
    }
}
