//
//  ExpenseRecord.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation
import SwiftData

@Model
final class ExpenseRecord {
    @Attribute(.unique) var id: UUID
    var name: String
    var amount: Decimal
    var category: String
    var date: Date

    init(_ expense: Expense) {
        id = expense.id
        name = expense.name
        amount = expense.amount
        category = expense.category.rawValue
        date = expense.date
    }

    var expense: Expense {
        Expense(
            id: id,
            name: name,
            amount: amount,
            category: ExpenseCategory(rawValue: category) ?? .foodAndBeverage,
            date: date)
    }
}
