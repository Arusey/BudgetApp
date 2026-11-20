//
//  HomeViewModelTests.swift
//  BudgetTests
//
//  Created by Kevin Lagat on 20/11/2026.
//

import XCTest
import Foundation
@testable import Budget

@MainActor
final class HomeViewModelTests: XCTestCase {
    private let calendar = Calendar(identifier: .gregorian)

    private func date(month: Int, day: Int, hour: Int = 12) -> Date {
        calendar.date(from: DateComponents(year: 2024, month: month, day: day, hour: hour))!
    }

    private func makeViewModel(
        expenses: [Expense] = [],
        monthlyBudget: Decimal = BudgetDefaults.monthlyBudget,
        scenario: MockBudgetRepository.Scenario = .success) -> HomeViewModel {
            let repository = MockBudgetRepository(expenses: expenses, monthlyBudget: monthlyBudget, scenario: scenario)
            let viewModel = HomeViewModel(repository: repository, calendar: calendar, now: date(month: 11, day: 27))
            viewModel.load()
            return viewModel
        }

    private var novemberExpenses: [Expense] {
        [
            Expense(name: "Naivas", amount: 5000, category: .foodAndBeverage, date: date(month: 11, day: 20)),
            Expense(name: "KFC", amount: 2000, category: .foodAndBeverage, date: date(month: 11, day: 27)),
            Expense(name: "Fuel", amount: 5000, category: .transportAndFuel, date: date(month: 11, day: 5)),
            Expense(name: "Jacket", amount: 3000, category: .clothing, date: date(month: 11, day: 10)),
            Expense(name: "M-Pesa", amount: 2000, category: .transactionFees, date: date(month: 11, day: 15))
        ]
    }

    func testEmptyStoreShowsFullDefaultBudget() {
        let viewModel = makeViewModel()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.remaining, 200_000)
        XCTAssertEqual(viewModel.totalSpend, 0)
        XCTAssertTrue(viewModel.recentTransactions.isEmpty)
        XCTAssertEqual(viewModel.categoryTotals.count, 4)
        XCTAssertTrue(viewModel.categoryTotals.allSatisfy { $0.amount == 0 })
    }

    func testRemainingIsBudgetMinusMonthSpend() {
        let viewModel = makeViewModel(expenses: novemberExpenses)

        XCTAssertEqual(viewModel.totalSpend, 17_000)
        XCTAssertEqual(viewModel.remaining, 183_000)
    }

    func testRemainingUsesStoredMonthlyBudget() {
        let viewModel = makeViewModel(expenses: novemberExpenses, monthlyBudget: 50_000)

        XCTAssertEqual(viewModel.remaining, 33_000)
    }

    func testCategoryTotalsSumPerCategory() {
        let viewModel = makeViewModel(expenses: novemberExpenses)

        let totals = Dictionary(uniqueKeysWithValues: viewModel.categoryTotals.map { ($0.category, $0.amount) })

        XCTAssertEqual(totals[.foodAndBeverage], 7000)
        XCTAssertEqual(totals[.transportAndFuel], 5000)
        XCTAssertEqual(totals[.clothing], 3000)
        XCTAssertEqual(totals[.transactionFees], 2000)
    }

    func testOtherMonthsAreExcluded() {
        let october = Expense(name: "Shoes", amount: 9000, category: .clothing, date: date(month: 10, day: 31))
        let viewModel = makeViewModel(expenses: novemberExpenses + [october])

        XCTAssertEqual(viewModel.totalSpend, 17_000)
        XCTAssertFalse(viewModel.recentTransactions.contains(october))
    }

    func testSelectingMonthFiltersData() {
        let october = Expense(name: "Shoes", amount: 9000, category: .clothing, date: date(month: 10, day: 31))
        let viewModel = makeViewModel(expenses: novemberExpenses + [october])

        viewModel.selectedMonth = date(month: 10, day: 1)

        XCTAssertEqual(viewModel.totalSpend, 9000)
        XCTAssertEqual(viewModel.remaining, 191_000)
        XCTAssertEqual(viewModel.recentTransactions, [october])
    }

    func testRecentTransactionsAreNewestFirstAndLimitedToFive() {
        let extra = Expense(name: "Coffee", amount: 300, category: .foodAndBeverage, date: date(month: 11, day: 1))
        let viewModel = makeViewModel(expenses: novemberExpenses + [extra])

        XCTAssertEqual(viewModel.recentTransactions.count, 5)
        XCTAssertEqual(viewModel.recentTransactions.first?.name, "KFC")
        XCTAssertFalse(viewModel.recentTransactions.contains(extra))
    }

    func testMonthsCoverCurrentYear() {
        let viewModel = makeViewModel()

        XCTAssertEqual(viewModel.months.count, 12)
        XCTAssertEqual(DateFormatting.month(viewModel.selectedMonth), "November")
    }

    func testLoadFailureShowsMessage() {
        let viewModel = makeViewModel(scenario: .failure)

        XCTAssertEqual(viewModel.state, .failed(BudgetError.loadFailed.localizedDescription))
    }
}
