//
//  AddItemViewModel.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class AddItemViewModel {
    enum State: Equatable {
        case idle, failed(String), saved(Expense)
    }

    var category: ExpenseCategory = .foodAndBeverage
    var name = ""
    var amountText = ""
    private(set) var nameError: String?
    private(set) var amountError: String?
    private(set) var state: State = .idle

    private let repository: any BudgetRepository

    init(repository: any BudgetRepository) {
        self.repository = repository
    }

    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let amount = CurrencyFormatter.decimal(from: amountText) ?? 0
        nameError = trimmedName.isEmpty ? BudgetError.emptyName.localizedDescription : nil
        amountError = amount > 0 ? nil : BudgetError.invalidAmount.localizedDescription
        guard nameError == nil, amountError == nil else { return }

        let expense = Expense(name: trimmedName, amount: amount, category: category, date: .now)
        do {
            try repository.add(expense)
            state = .saved(expense)
        } catch {
            state = .failed(BudgetError.saveFailed.localizedDescription)
        }
    }
}
