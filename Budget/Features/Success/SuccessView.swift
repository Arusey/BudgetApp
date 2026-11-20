//
//  SuccessView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct SuccessView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isCheckVisible = false
    @State private var isRating = false
    let expense: Expense
    let onGoHome: () -> Void

    private var accent: Color {
        colorScheme == .dark ? AppColor.primary : AppColor.secondary
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                checkmark
                VStack(spacing: 8) {
                    Text("Budget Item Added")
                        .font(AppFont.bold(24, relativeTo: .title2))
                        .foregroundStyle(accent)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityIdentifier("successTitle")
                    Text("Budget item has been added successfully.")
                        .font(AppFont.regular(14, relativeTo: .subheadline))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                Divider()
                VStack(spacing: 16) {
                    row("Budget Item Name", value: expense.name)
                    row("Amount", value: CurrencyFormatter.compact(expense.amount), color: AppColor.primary)
                    row("Date", value: DateFormatting.long(expense.date))
                }
                VStack(spacing: 12) {
                    PrimaryButton(title: "Go back to Home", color: AppColor.secondary, action: onGoHome)
                        .accessibilityIdentifier("goHomeButton")
                    OutlinedButton(title: "Rate your Experience", color: accent) {
                        isRating = true
                    }
                    .accessibilityIdentifier("rateButton")
                }
                .padding(.top, 16)
            }
            .padding(20)
            .padding(.top, 24)
        }
        .background(AppColor.background)
        .overlay {
            ConfettiView()
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isRating) {
            RatingSheet()
        }
        .onAppear {
            isCheckVisible = true
        }
    }

    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 40, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 104, height: 104)
            .background(AppColor.heroGradient, in: Circle())
            .scaleEffect(isCheckVisible ? 1 : 0.3)
            .opacity(isCheckVisible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isCheckVisible)
            .accessibilityHidden(true)
    }

    private func row(_ title: String, value: String, color: Color = .primary) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppFont.regular(14, relativeTo: .subheadline))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(AppFont.bold(16))
                .foregroundStyle(color)
                .multilineTextAlignment(.trailing)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Light") {
    NavigationStack {
        SuccessView(expense: MockBudgetRepository.sampleExpenses[1], onGoHome: {})
    }
}

#Preview("Dark") {
    NavigationStack {
        SuccessView(expense: MockBudgetRepository.sampleExpenses[1], onGoHome: {})
    }
    .preferredColorScheme(.dark)
}
