//
//  EditBudgetSheet.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct EditBudgetSheet: View {
    @Bindable var viewModel: BudgetsViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Monthly Budget")
                .font(AppFont.bold(20, relativeTo: .title3))
                .accessibilityAddTraits(.isHeader)
            OutlinedField("Amount", isFocused: isFocused, error: viewModel.budgetError) {
                HStack(spacing: 12) {
                    Text("KSh")
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Rectangle()
                        .fill(AppColor.border)
                        .frame(width: 1, height: 24)
                    TextField("0", text: $viewModel.budgetText)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                        .accessibilityLabel("Monthly budget in Kenya shillings")
                        .accessibilityIdentifier("budgetField")
                }
            }
            PrimaryButton(title: "Save") {
                viewModel.saveBudget()
            }
            .accessibilityIdentifier("saveBudgetButton")
            Spacer(minLength: 0)
        }
        .padding(24)
        .padding(.top, 8)
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    let viewModel = BudgetsViewModel(repository: MockBudgetRepository.preview)

    Color.clear
        .sheet(isPresented: .constant(true)) {
            EditBudgetSheet(viewModel: viewModel)
        }
        .onAppear {
            viewModel.startEditingBudget()
        }
}
