//
//  SpendChartView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI
import Charts

struct SpendChartView: View {
    let totals: [CategoryTotal]

    private var total: Double {
        totals.reduce(0) { $0 + $1.chartValue }
    }

    var body: some View {
        VStack(spacing: 16) {
            if total > 0 {
                Chart(totals) { item in
                    BarMark(x: .value("Amount", item.chartValue))
                        .foregroundStyle(item.category.color)
                }
                .chartXScale(domain: 0...total)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
                .frame(height: 16)
                .clipShape(Capsule())
                .accessibilityLabel("Spend by category")
            } else {
                Capsule()
                    .fill(AppColor.border)
                    .frame(height: 16)
                    .accessibilityHidden(true)
            }
            VStack(spacing: 12) {
                ForEach(totals) { item in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(item.category.color)
                            .frame(width: 10, height: 10)
                        Text(item.category.name)
                            .font(AppFont.regular(14, relativeTo: .subheadline))
                        Spacer()
                        Text(CurrencyFormatter.string(item.amount))
                            .font(AppFont.bold(14, relativeTo: .subheadline))
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        SpendChartView(totals: MockBudgetRepository.sampleExpenses.categoryTotals)
        SpendChartView(totals: [Expense]().categoryTotals)
    }
    .padding()
}
