//
//  TransactionRow.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct TransactionRow: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            icon
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.name)
                    .font(AppFont.bold(16))
                    .lineLimit(1)
                Text(DateFormatting.transaction(expense.date))
                    .font(AppFont.regular(12, relativeTo: .caption))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(CurrencyFormatter.string(expense.amount))
                    .font(AppFont.bold(14, relativeTo: .subheadline))
                    .foregroundStyle(AppColor.expense)
                Text(expense.category.name)
                    .font(AppFont.regular(12, relativeTo: .caption))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColor.border, lineWidth: 1))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var icon: some View {
        if let logo = expense.logo {
            Image(logo)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } else {
            Image(systemName: expense.category.icon)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(expense.category.color, in: Circle())
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        ForEach(MockBudgetRepository.sampleExpenses) { expense in
            TransactionRow(expense: expense)
        }
    }
    .padding()
    .background(AppColor.background)
}
