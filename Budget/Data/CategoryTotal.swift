//
//  CategoryTotal.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

struct CategoryTotal: Identifiable, Equatable {
    let category: ExpenseCategory
    let amount: Decimal

    var id: String { category.id }

    var chartValue: Double {
        NSDecimalNumber(decimal: amount).doubleValue
    }
}
