//
//  SwiftDataBudgetRepository.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation
import SwiftData

final class SwiftDataBudgetRepository: BudgetRepository {
    private let container: ModelContainer

    private var context: ModelContext {
        container.mainContext
    }

    init(inMemory: Bool = false) throws {
        container = try ModelContainer(
            for: ExpenseRecord.self, BudgetRecord.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory))
    }

    func monthlyBudget() throws -> Decimal {
        try budgetRecord()?.amount ?? BudgetDefaults.monthlyBudget
    }

    func setMonthlyBudget(_ amount: Decimal) throws {
        if let record = try budgetRecord() {
            record.amount = amount
        } else {
            context.insert(BudgetRecord(amount: amount))
        }
        try context.save()
    }

    func expenses() throws -> [Expense] {
        let descriptor = FetchDescriptor<ExpenseRecord>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(descriptor).map(\.expense)
    }

    func add(_ expense: Expense) throws {
        context.insert(ExpenseRecord(expense))
        try context.save()
    }

    func delete(id: UUID) throws {
        let descriptor = FetchDescriptor<ExpenseRecord>(predicate: #Predicate { $0.id == id })
        for record in try context.fetch(descriptor) {
            context.delete(record)
        }
        try context.save()
    }

    private func budgetRecord() throws -> BudgetRecord? {
        try context.fetch(FetchDescriptor<BudgetRecord>()).first
    }
}
