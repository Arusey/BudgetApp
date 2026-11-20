//
//  BudgetApp.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI
import CoreData

@main
struct BudgetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
