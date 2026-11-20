//
//  Expense.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

struct Expense: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var amount: Decimal
    var category: ExpenseCategory
    var date: Date

    var logo: String? {
        ["kfc", "naivas", "paul", "total"].first { name.localizedCaseInsensitiveContains($0) }
    }
}

extension [Expense] {
    var total: Decimal {
        reduce(0) { $0 + $1.amount }
    }

    var categoryTotals: [CategoryTotal] {
        ExpenseCategory.allCases.map { category in
            CategoryTotal(category: category, amount: filter { $0.category == category }.total)
        }
    }

    func inMonth(of date: Date, calendar: Calendar = .current) -> [Expense] {
        filter { calendar.isDate($0.date, equalTo: date, toGranularity: .month) }
    }
}
