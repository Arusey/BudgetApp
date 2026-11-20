//
//  AddItemViewModelTests.swift
//  BudgetTests
//
//  Created by Kevin Lagat on 20/11/2026.
//

import XCTest
import Foundation
@testable import Budget

@MainActor
final class AddItemViewModelTests: XCTestCase {
    private func makeViewModel(
        repository: MockBudgetRepository,
        name: String = "KFC",
        amount: String = "2000") -> AddItemViewModel {
            let viewModel = AddItemViewModel(repository: repository)
            viewModel.name = name
            viewModel.amountText = amount
            return viewModel
        }

    func testEmptyNameShowsErrorAndSavesNothing() throws {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository, name: "   ")

        viewModel.save()

        XCTAssertEqual(viewModel.nameError, BudgetError.emptyName.localizedDescription)
        XCTAssertNil(viewModel.amountError)
        XCTAssertEqual(viewModel.state, .idle)
        XCTAssertTrue(try repository.expenses().isEmpty)
    }

    func testZeroAmountShowsError() throws {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository, amount: "0")

        viewModel.save()

        XCTAssertNil(viewModel.nameError)
        XCTAssertEqual(viewModel.amountError, BudgetError.invalidAmount.localizedDescription)
        XCTAssertTrue(try repository.expenses().isEmpty)
    }

    func testNonNumericAmountShowsError() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(), amount: "12abc")

        viewModel.save()

        XCTAssertEqual(viewModel.amountError, BudgetError.invalidAmount.localizedDescription)
        XCTAssertEqual(viewModel.state, .idle)
    }

    func testBothFieldsInvalidShowsBothErrors() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(), name: "", amount: "")

        viewModel.save()

        XCTAssertNotNil(viewModel.nameError)
        XCTAssertNotNil(viewModel.amountError)
    }

    func testErrorsClearAfterFixingInput() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(), name: "", amount: "")
        viewModel.save()

        viewModel.name = "KFC"
        viewModel.amountText = "2000"
        viewModel.save()

        XCTAssertNil(viewModel.nameError)
        XCTAssertNil(viewModel.amountError)
    }

    func testValidItemIsSavedWithTrimmedName() throws {
        let repository = MockBudgetRepository()
        let viewModel = makeViewModel(repository: repository, name: "  KFC Lunch ", amount: "2000.50")
        viewModel.category = .transportAndFuel

        viewModel.save()

        let saved = try XCTUnwrap(try repository.expenses().first)
        XCTAssertEqual(viewModel.state, .saved(saved))
        XCTAssertEqual(saved.name, "KFC Lunch")
        XCTAssertEqual(saved.amount, Decimal(string: "2000.5"))
        XCTAssertEqual(saved.category, .transportAndFuel)
    }

    func testSaveFailureShowsMessage() {
        let viewModel = makeViewModel(repository: MockBudgetRepository(scenario: .failure))

        viewModel.save()

        XCTAssertEqual(viewModel.state, .failed(BudgetError.saveFailed.localizedDescription))
    }

    func testSavedItemUpdatesHomeBalance() {
        let repository = MockBudgetRepository()
        let home = HomeViewModel(repository: repository)
        let viewModel = makeViewModel(repository: repository)

        viewModel.save()
        home.load()

        XCTAssertEqual(home.totalSpend, 2000)
        XCTAssertEqual(home.remaining, 198_000)
        XCTAssertEqual(home.recentTransactions.first?.name, "KFC")
    }
}
