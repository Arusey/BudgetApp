//
//  AddItemView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct AddItemView: View {
    private enum Field {
        case name, amount
    }

    @State private var viewModel: AddItemViewModel
    @FocusState private var focusedField: Field?
    let onSaved: (Expense) -> Void
    let onClose: () -> Void

    init(viewModel: AddItemViewModel, onSaved: @escaping (Expense) -> Void, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onSaved = onSaved
        self.onClose = onClose
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add New Budget Item")
                    .font(AppFont.bold(24, relativeTo: .title2))
                    .accessibilityAddTraits(.isHeader)
                categoryField
                nameField
                amountField
                if case .failed(let message) = viewModel.state {
                    Text(message)
                        .font(AppFont.regular(14, relativeTo: .subheadline))
                        .foregroundStyle(AppColor.expense)
                }
                PrimaryButton(title: "Create New Budget Item") {
                    focusedField = nil
                    viewModel.save()
                }
                .padding(.top, 12)
                .accessibilityIdentifier("createButton")
            }
            .padding(20)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(AppColor.background)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                }
                .tint(Color.primary)
                .accessibilityLabel("Close")
            }
        }
        .onChange(of: viewModel.state) { _, newState in
            if case .saved(let expense) = newState { onSaved(expense) }
        }
    }

    private var categoryField: some View {
        OutlinedField("Category") {
            Menu {
                Picker("Category", selection: $viewModel.category) {
                    ForEach(ExpenseCategory.allCases) { category in
                        Text(category.name).tag(category)
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Circle()
                        .fill(viewModel.category.color)
                        .frame(width: 10, height: 10)
                    Text(viewModel.category.name)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(.primary)
                .contentShape(Rectangle())
            }
            .accessibilityLabel("Category, \(viewModel.category.name)")
            .accessibilityIdentifier("categoryPicker")
        }
    }

    private var nameField: some View {
        OutlinedField("Item Name", isFocused: focusedField == .name, error: viewModel.nameError) {
            TextField("e.g. Lunch at KFC", text: $viewModel.name)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .amount }
                .accessibilityLabel("Item name")
                .accessibilityIdentifier("itemNameField")
        }
    }

    private var amountField: some View {
        OutlinedField("Allocation", isFocused: focusedField == .amount, error: viewModel.amountError) {
            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Text("KSh")
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                }
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
                Rectangle()
                    .fill(AppColor.border)
                    .frame(width: 1, height: 24)
                TextField("0", text: $viewModel.amountText)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .amount)
                    .accessibilityLabel("Allocation in Kenya shillings")
                    .accessibilityIdentifier("amountField")
            }
        }
    }
}

#Preview("Empty") {
    NavigationStack {
        AddItemView(viewModel: AddItemViewModel(repository: MockBudgetRepository()), onSaved: { _ in }, onClose: {})
    }
}

#Preview("Save fails") {
    NavigationStack {
        AddItemView(
            viewModel: AddItemViewModel(repository: MockBudgetRepository(scenario: .failure)),
            onSaved: { _ in },
            onClose: {})
    }
    .preferredColorScheme(.dark)
}
