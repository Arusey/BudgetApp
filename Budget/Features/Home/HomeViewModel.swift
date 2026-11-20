//
//  HomeViewModel.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    enum State: Equatable {
        case idle, loaded, failed(String)
    }

    let userName = "John Doe"
    let months: [Date]
    var selectedMonth: Date
    private(set) var state: State = .idle
    private(set) var monthlyBudget = BudgetDefaults.monthlyBudget
    private var expenses: [Expense] = []

    private let repository: any BudgetRepository
    private let calendar: Calendar

    init(repository: any BudgetRepository, calendar: Calendar = .current, now: Date = .now) {
        self.repository = repository
        self.calendar = calendar
        let year = calendar.component(.year, from: now)
        months = (1...12).compactMap { calendar.date(from: DateComponents(year: year, month: $0)) }
        selectedMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
    }

    var monthExpenses: [Expense] {
        expenses.inMonth(of: selectedMonth, calendar: calendar)
    }

    var totalSpend: Decimal {
        monthExpenses.total
    }

    var remaining: Decimal {
        monthlyBudget - totalSpend
    }

    var categoryTotals: [CategoryTotal] {
        monthExpenses.categoryTotals
    }

    var recentTransactions: [Expense] {
        Array(monthExpenses.prefix(5))
    }

    func load() {
        do {
            monthlyBudget = try repository.monthlyBudget()
            expenses = try repository.expenses()
            state = .loaded
        } catch {
            state = .failed(BudgetError.loadFailed.localizedDescription)
        }
    }
}
