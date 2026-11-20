//
//  BudgetRepository.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

protocol BudgetRepository {
    func monthlyBudget() throws -> Decimal
    func setMonthlyBudget(_ amount: Decimal) throws
    func expenses() throws -> [Expense]
    func add(_ expense: Expense) throws
    func delete(id: UUID) throws
}

enum BudgetDefaults {
    static let monthlyBudget: Decimal = 200_000
}
