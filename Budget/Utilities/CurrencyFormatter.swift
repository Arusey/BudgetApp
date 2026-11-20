//
//  CurrencyFormatter.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

enum CurrencyFormatter {
    static func number(_ value: Decimal, fractionDigits: Int = 1) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(fractionDigits))
                .grouping(.never)
                .locale(Locale(identifier: "en_US_POSIX")))
    }

    static func string(_ value: Decimal, symbol: String = "Ksh.", fractionDigits: Int = 1) -> String {
        "\(symbol) \(number(value, fractionDigits: fractionDigits))"
    }
}
