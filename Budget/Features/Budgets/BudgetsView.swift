//
//  BudgetsView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct BudgetsView: View {
    @State private var viewModel: BudgetsViewModel

    init(viewModel: BudgetsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            Group {
                Text("Budgets")
                    .font(AppFont.bold(28, relativeTo: .largeTitle))
                    .accessibilityAddTraits(.isHeader)
                budgetCard
                if case .failed(let message) = viewModel.state {
                    Text(message)
                        .font(AppFont.regular(14, relativeTo: .subheadline))
                        .foregroundStyle(AppColor.expense)
                }
                if viewModel.sections.isEmpty {
                    emptyState
                }
            }
            .listRowStyle()

            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.expenses) { expense in
                        TransactionRow(expense: expense)
                            .listRowStyle()
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        viewModel.delete(expense)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                } header: {
                    sectionHeader(section)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(AppColor.background)
        .task {
            viewModel.load()
        }
        .sheet(isPresented: $viewModel.isEditingBudget) {
            EditBudgetSheet(viewModel: viewModel)
        }
    }

    private var budgetCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Monthly Budget")
                    .font(AppFont.regular(14, relativeTo: .subheadline))
                    .foregroundStyle(.secondary)
                Text(CurrencyFormatter.string(viewModel.monthlyBudget, symbol: "Ksh"))
                    .font(AppFont.bold(22, relativeTo: .title2))
                    .accessibilityIdentifier("monthlyBudgetValue")
            }
            Spacer()
            Button {
                viewModel.startEditingBudget()
            } label: {
                Label("Edit", systemImage: "pencil")
                    .font(AppFont.bold(14, relativeTo: .subheadline))
                    .foregroundStyle(AppColor.primary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .overlay(Capsule().stroke(AppColor.primary, lineWidth: 1.5))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit monthly budget")
            .accessibilityIdentifier("editBudgetButton")
        }
        .padding(16)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border, lineWidth: 1))
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("No budget items yet")
                .font(AppFont.bold(16))
            Text("Tap + to add your first budget item")
                .font(AppFont.regular(14, relativeTo: .subheadline))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .accessibilityElement(children: .combine)
    }

    private func sectionHeader(_ section: BudgetsViewModel.CategorySection) -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(section.category.color)
                .frame(width: 10, height: 10)
            Text(section.category.name)
                .font(AppFont.bold(16))
                .foregroundStyle(.primary)
            Spacer()
            Text(CurrencyFormatter.string(section.total))
                .font(AppFont.bold(14, relativeTo: .subheadline))
                .foregroundStyle(.secondary)
        }
        .textCase(nil)
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

private extension View {
    func listRowStyle() -> some View {
        listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
    }
}

#Preview("With data") {
    BudgetsView(viewModel: BudgetsViewModel(repository: MockBudgetRepository.preview))
}

#Preview("Empty") {
    BudgetsView(viewModel: BudgetsViewModel(repository: MockBudgetRepository()))
        .preferredColorScheme(.dark)
}
