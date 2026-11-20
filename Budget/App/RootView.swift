//
//  RootView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct RootView: View {
    @State private var selectedTab: AppTab = .home
    @State private var isAddingItem = false
    @State private var savedExpense: Expense?
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
            case .budgets:
                BudgetsView(viewModel: BudgetsViewModel(repository: repository))
            case .reports, .account:
                Text(selectedTab.title)
                    .font(AppFont.bold(22, relativeTo: .title2))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background.ignoresSafeArea())
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selection: $selectedTab, onAdd: { isAddingItem = true })
        }
        .fullScreenCover(isPresented: $isAddingItem, onDismiss: didFinishAdding) {
            NavigationStack {
                AddItemView(
                    viewModel: AddItemViewModel(repository: repository),
                    onSaved: { savedExpense = $0 },
                    onClose: { isAddingItem = false })
                .navigationDestination(item: $savedExpense) { expense in
                    SuccessView(expense: expense, onGoHome: goHome)
                }
            }
        }
    }

    private func goHome() {
        selectedTab = .home
        isAddingItem = false
    }

    private func didFinishAdding() {
        savedExpense = nil
        homeViewModel.load()
    }
}

#Preview {
    RootView(repository: MockBudgetRepository.preview)
}
