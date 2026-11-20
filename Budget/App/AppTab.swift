//
//  AppTab.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

enum AppTab: String, CaseIterable {
    case home, budgets, reports, account

    var title: String {
        switch self {
        case .home:
            "Home"
        case .budgets:
            "Budgets"
        case .reports:
            "Reports"
        case .account:
            "Account"
        }
    }

    var icon: String {
        switch self {
        case .home:
            "house"
        case .budgets:
            "wallet.bifold"
        case .reports:
            "chart.bar"
        case .account:
            "person"
        }
    }
}
