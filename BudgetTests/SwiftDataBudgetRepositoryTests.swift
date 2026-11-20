//
//  SwiftDataBudgetRepositoryTests.swift
//  BudgetTests
//
//  Created by Kevin Lagat on 20/11/2026.
//

import XCTest
import Foundation
@testable import Budget

@MainActor
final class SwiftDataBudgetRepositoryTests: XCTestCase {
    private func makeRepository() throws -> SwiftDataBudgetRepository {
        try SwiftDataBudgetRepository(inMemory: true)
    }

    private func expense(_ name: String, amount: Decimal = 1000, daysAgo: Double = 0) -> Expense {
        Expense(
            name: name,
            amount: amount,
            category: .clothing,
            date: Date(timeIntervalSince1970: 1_732_700_000 - daysAgo * 86_400))
    }

    func testMonthlyBudgetDefaultsToTwoHundredThousand() throws {
        let repository = try makeRepository()

        XCTAssertEqual(try repository.monthlyBudget(), 200_000)
    }

    func testSetMonthlyBudgetReplacesStoredValue() throws {
        let repository = try makeRepository()

        try repository.setMonthlyBudget(150_000)
        try repository.setMonthlyBudget(120_000)

        XCTAssertEqual(try repository.monthlyBudget(), 120_000)
    }

    func testAddedExpenseIsReturnedUnchanged() throws {
        let repository = try makeRepository()
        let item = expense("Jacket", amount: Decimal(string: "3000.75")!)

        try repository.add(item)

        XCTAssertEqual(try repository.expenses(), [item])
    }

    func testExpensesAreNewestFirst() throws {
        let repository = try makeRepository()
        try repository.add(expense("Old", daysAgo: 2))
        try repository.add(expense("New"))
        try repository.add(expense("Middle", daysAgo: 1))

        XCTAssertEqual(try repository.expenses().map(\.name), ["New", "Middle", "Old"])
    }

    func testDeleteRemovesOnlyMatchingExpense() throws {
        let repository = try makeRepository()
        let keep = expense("Keep")
        let remove = expense("Remove", daysAgo: 1)
        try repository.add(keep)
        try repository.add(remove)

        try repository.delete(id: remove.id)

        XCTAssertEqual(try repository.expenses(), [keep])
    }
}
