//
//  BudgetsViewModel.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class BudgetsViewModel {
    enum State: Equatable {
        case idle, loaded, failed(String)
    }

    struct CategorySection: Identifiable, Equatable {
        let category: ExpenseCategory
        let expenses: [Expense]

        var id: String { category.id }
        var total: Decimal { expenses.total }
    }

    var isEditingBudget = false
    var budgetText = ""
    private(set) var budgetError: String?
    private(set) var state: State = .idle
    private(set) var monthlyBudget = BudgetDefaults.monthlyBudget
    private var expenses: [Expense] = []

    private let repository: any BudgetRepository

    init(repository: any BudgetRepository) {
        self.repository = repository
    }

    var sections: [CategorySection] {
        ExpenseCategory.allCases.compactMap { category in
            let matching = expenses.filter { $0.category == category }
            return matching.isEmpty ? nil : CategorySection(category: category, expenses: matching)
        }
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

    func delete(_ expense: Expense) {
        do {
            try repository.delete(id: expense.id)
            expenses.removeAll { $0.id == expense.id }
            state = .loaded
        } catch {
            state = .failed(BudgetError.saveFailed.localizedDescription)
        }
    }

    func startEditingBudget() {
        budgetText = CurrencyFormatter.plain(monthlyBudget)
        budgetError = nil
        isEditingBudget = true
    }

    func saveBudget() {
        guard let amount = CurrencyFormatter.decimal(from: budgetText), amount > 0 else {
            budgetError = BudgetError.invalidAmount.localizedDescription
            return
        }
        do {
            try repository.setMonthlyBudget(amount)
            monthlyBudget = amount
            isEditingBudget = false
        } catch {
            budgetError = BudgetError.saveFailed.localizedDescription
        }
    }
}
