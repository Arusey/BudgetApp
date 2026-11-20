//
//  RootView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: AppTab = .home
    @State private var homeViewModel: HomeViewModel
    private let repository: any BudgetRepository

    init(repository: any BudgetRepository) {
        _homeViewModel = State(initialValue: HomeViewModel(repository: repository))
        self.repository = repository
    }

    var body: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeView(viewModel: homeViewModel, onViewAll: { selectedTab = .budgets })
            case .budgets, .reports, .account:
                Text(selectedTab.title)
                    .font(AppFont.bold(22, relativeTo: .title2))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background.ignoresSafeArea())
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selection: $selectedTab, onAdd: {})
        }
    }
}

#Preview {
    RootView(repository: MockBudgetRepository.preview)
}
