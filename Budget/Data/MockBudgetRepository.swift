//
//  MockBudgetRepository.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

final class MockBudgetRepository: BudgetRepository {
    enum Scenario {
        case success, failure
    }

    var scenario: Scenario
    private var budget: Decimal
    private var stored: [Expense]

    init(
        expenses: [Expense] = [],
        monthlyBudget: Decimal = BudgetDefaults.monthlyBudget,
        scenario: Scenario = .success
    ) {
        stored = expenses
        budget = monthlyBudget
        self.scenario = scenario
    }

    static var preview: MockBudgetRepository {
        MockBudgetRepository(expenses: sampleExpenses)
    }

    static var sampleExpenses: [Expense] {
        let now = Date.now
        return [
            Expense(name: "Naivas Supermarket", amount: 5000, category: .foodAndBeverage, date: now),
            Expense(name: "KFC", amount: 2000, category: .foodAndBeverage, date: now.addingTimeInterval(-3_600)),
            Expense(name: "Total Energies", amount: 5000, category: .transportAndFuel, date: now.addingTimeInterval(-7_200)),
            Expense(name: "Jacket", amount: 3000, category: .clothing, date: now.addingTimeInterval(-10_800)),
            Expense(name: "M-Pesa Charges", amount: 2000, category: .transactionFees, date: now.addingTimeInterval(-14_400))
        ]
    }

    func monthlyBudget() throws -> Decimal {
        try simulate(.loadFailed)
        return budget
    }

    func setMonthlyBudget(_ amount: Decimal) throws {
        try simulate(.saveFailed)
        budget = amount
    }

    func expenses() throws -> [Expense] {
        try simulate(.loadFailed)
        return stored.sorted { $0.date > $1.date }
    }

    func add(_ expense: Expense) throws {
        try simulate(.saveFailed)
        stored.append(expense)
    }

    func delete(id: UUID) throws {
        try simulate(.saveFailed)
        stored.removeAll { $0.id == id }
    }

    private func simulate(_ error: BudgetError) throws {
        if scenario == .failure { throw error }
    }
}
