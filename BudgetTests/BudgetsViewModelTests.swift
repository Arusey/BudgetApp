//
//  BudgetsViewModelTests.swift
//  BudgetTests
//
//  Created by Kevin Lagat on 20/11/2026.
//

import XCTest
import Foundation
@testable import Budget

@MainActor
final class BudgetsViewModelTests: XCTestCase {
    private let jacket = Expense(
        name: "Jacket",
        amount: 3000,
        category: .clothing,
        date: Date(timeIntervalSince1970: 1_732_700_000))
    private let fuel = Expense(
        name: "Fuel",
        amount: 5000,
        category: .transportAndFuel,
        date: Date(timeIntervalSince1970: 1_732_600_000))
    private let taxi = Expense(
        name: "Taxi",
        amount: 800,
        category: .transportAndFuel,
        date: Date(timeIntervalSince1970: 1_732_500_000))

    private func makeViewModel(repository: MockBudgetRepository) -> BudgetsViewModel {
        let viewModel = BudgetsViewModel(repository: repository)
        viewModel.load()
        return viewModel
    }

    func testEmptyStoreHasNoSections() {
        let viewModel = makeViewModel(repository: MockBudgetRepository())

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertEqual(viewModel.monthlyBudget, 200_000)
    }

    func testSectionsGroupExpensesByCategory() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(expenses: [jacket, fuel, taxi]))

        XCTAssertEqual(viewModel.sections.map(\.category), [.transportAndFuel, .clothing])
        XCTAssertEqual(viewModel.sections.first?.expenses, [fuel, taxi])
        XCTAssertEqual(viewModel.sections.last?.expenses, [jacket])
    }

    func testSectionTotalSumsItsExpenses() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(expenses: [jacket, fuel, taxi]))

        XCTAssertEqual(viewModel.sections.first?.total, 5800)
        XCTAssertEqual(viewModel.sections.last?.total, 3000)
    }

    func testLoadUsesStoredMonthlyBudget() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(monthlyBudget: 150_000))

        XCTAssertEqual(viewModel.monthlyBudget, 150_000)
    }

    func testLoadFailureShowsMessage() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(scenario: .failure))

        XCTAssertEqual(viewModel.state, .failed(BudgetError.loadFailed.localizedDescription))
    }

    func testDeleteRemovesExpenseFromStoreAndSection() throws {
        let repository = MockBudgetRepository(expenses: [jacket, fuel, taxi])
        let viewModel = makeViewModel(repository: repository)

        viewModel.delete(taxi)

        XCTAssertEqual(viewModel.sections.first?.expenses, [fuel])
        XCTAssertEqual(try repository.expenses(), [jacket, fuel])
    }

    func testDeletingLastExpenseRemovesItsSection() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(expenses: [jacket, fuel]))

        viewModel.delete(jacket)

        XCTAssertEqual(viewModel.sections.map(\.category), [.transportAndFuel])
    }

    func testDeleteFailureKeepsExpenseAndShowsMessage() {
        let repository = MockBudgetRepository(expenses: [jacket])
        let viewModel = makeViewModel(repository: repository)
        repository.scenario = .failure

        viewModel.delete(jacket)

        XCTAssertEqual(viewModel.state, .failed(BudgetError.saveFailed.localizedDescription))
        XCTAssertEqual(viewModel.sections.first?.expenses, [jacket])
    }

    func testStartEditingPrefillsCurrentBudget() {
        let viewModel = makeViewModel(repository: MockBudgetRepository())

        viewModel.startEditingBudget()

        XCTAssertTrue(viewModel.isEditingBudget)
        XCTAssertEqual(viewModel.budgetText, "200000")
        XCTAssertNil(viewModel.budgetError)
    }

    func testSaveBudgetPersistsAndClosesEditor() throws {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository)
        viewModel.startEditingBudget()
        viewModel.budgetText = "150000"

        viewModel.saveBudget()

        XCTAssertEqual(viewModel.monthlyBudget, 150_000)
        XCTAssertEqual(try repository.monthlyBudget(), 150_000)
        XCTAssertFalse(viewModel.isEditingBudget)
        XCTAssertNil(viewModel.budgetError)
    }

    func testSaveBudgetRejectsInvalidAmounts() throws {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository)
        viewModel.startEditingBudget()

        for text in ["", "0", "abc", "12abc"] {
            viewModel.budgetText = text
            viewModel.saveBudget()

            XCTAssertEqual(viewModel.budgetError, BudgetError.invalidAmount.localizedDescription, text)
        }
        XCTAssertTrue(viewModel.isEditingBudget)
        XCTAssertEqual(viewModel.monthlyBudget, 200_000)
        XCTAssertEqual(try repository.monthlyBudget(), 200_000)
    }

    func testStartEditingClearsPreviousError() {
        let viewModel = makeViewModel(repository: MockBudgetRepository())
        viewModel.startEditingBudget()
        viewModel.budgetText = "0"
        viewModel.saveBudget()

        viewModel.startEditingBudget()

        XCTAssertNil(viewModel.budgetError)
        XCTAssertEqual(viewModel.budgetText, "200000")
    }

    func testSaveBudgetFailureShowsMessageAndKeepsEditorOpen() {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository)
        viewModel.startEditingBudget()
        viewModel.budgetText = "150000"
        repository.scenario = .failure

        viewModel.saveBudget()

        XCTAssertEqual(viewModel.budgetError, BudgetError.saveFailed.localizedDescription)
        XCTAssertTrue(viewModel.isEditingBudget)
        XCTAssertEqual(viewModel.monthlyBudget, 200_000)
    }

    func testSavedBudgetChangesHomeBalance() {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository)
        viewModel.startEditingBudget()
        viewModel.budgetText = "150000"

        viewModel.saveBudget()
        let home = HomeViewModel(repository: repository)
        home.load()

        XCTAssertEqual(home.remaining, 150_000)
    }
}
