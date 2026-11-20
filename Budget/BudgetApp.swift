//
//  BudgetApp.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI
import Foundation

@main
struct BudgetApp: App {
    private let repository: any BudgetRepository

    init() {
        let inMemory = ProcessInfo.processInfo.arguments.contains("-uiTesting")
        do {
            repository = try SwiftDataBudgetRepository(inMemory: inMemory)
        } catch {
            repository = MockBudgetRepository()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(repository: repository)
        }
    }
}
