//
//  HomeView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    let onViewAll: () -> Void

    init(viewModel: HomeViewModel, onViewAll: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onViewAll = onViewAll
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                if case .failed(let message) = viewModel.state {
                    Text(message)
                        .font(AppFont.regular(14, relativeTo: .subheadline))
                        .foregroundStyle(AppColor.expense)
                }
                balanceCard
                spendSection
                transactionsSection
            }
            .padding(20)
        }
        .background(AppColor.background)
        .task {
            viewModel.load()
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("Welcome back,")
                    .font(AppFont.regular(14, relativeTo: .subheadline))
                    .foregroundStyle(.secondary)
                Text("\(viewModel.userName) 👋")
                    .font(AppFont.bold(18, relativeTo: .headline))
            }
            .accessibilityElement(children: .combine)
            Spacer()
            Button {
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundStyle(AppColor.primary)
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(AppColor.primary, lineWidth: 1.5))
            }
            .accessibilityLabel("Notifications")
        }
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(CurrencyFormatter.number(viewModel.remaining))
                    .font(AppFont.bold(40, relativeTo: .largeTitle))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text("Ksh.")
                    .font(AppFont.regular(16))
            }
            Text("remaining on your monthly budget")
                .font(AppFont.regular(14, relativeTo: .subheadline))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(AppColor.heroGradient, in: RoundedRectangle(cornerRadius: 20))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(CurrencyFormatter.string(viewModel.remaining, symbol: "Ksh")) remaining on your monthly budget")
        .accessibilityIdentifier("remainingBalance")
    }

    private var spendSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Spend this Month")
                        .font(AppFont.regular(14, relativeTo: .subheadline))
                        .foregroundStyle(.secondary)
                    Text(CurrencyFormatter.string(viewModel.totalSpend, symbol: "Ksh"))
                        .font(AppFont.bold(22, relativeTo: .title2))
                        .accessibilityIdentifier("totalSpend")
                }
                Spacer()
                monthMenu
            }
            SpendChartView(totals: viewModel.categoryTotals)
        }
    }

    private var monthMenu: some View {
        Menu {
            ForEach(viewModel.months, id: \.self) { month in
                Button(DateFormatting.month(month)) {
                    viewModel.selectedMonth = month
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(DateFormatting.month(viewModel.selectedMonth))
                    .font(AppFont.regular(14, relativeTo: .subheadline))
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(AppColor.border, lineWidth: 1))
        }
        .accessibilityLabel("Month, \(DateFormatting.month(viewModel.selectedMonth))")
        .accessibilityIdentifier("monthMenu")
    }

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Transactions")
                    .font(AppFont.bold(18, relativeTo: .headline))
                Spacer()
                Button(action: onViewAll) {
                    HStack(spacing: 4) {
                        Text("View All")
                        Image(systemName: "arrow.up.right")
                    }
                    .font(AppFont.bold(14, relativeTo: .subheadline))
                    .foregroundStyle(AppColor.primary)
                }
            }
            if viewModel.recentTransactions.isEmpty {
                emptyState
            } else {
                ForEach(viewModel.recentTransactions) { expense in
                    TransactionRow(expense: expense)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("No transactions yet")
                .font(AppFont.bold(16))
            Text("Tap + to add your first budget item")
                .font(AppFont.regular(14, relativeTo: .subheadline))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("emptyTransactions")
    }
}

#Preview("With data") {
    HomeView(viewModel: HomeViewModel(repository: MockBudgetRepository.preview), onViewAll: {})
}

#Preview("Empty") {
    HomeView(viewModel: HomeViewModel(repository: MockBudgetRepository()), onViewAll: {})
        .preferredColorScheme(.dark)
}
