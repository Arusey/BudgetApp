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

    static func plain(_ value: Decimal) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(0...2))
                .grouping(.never)
                .locale(Locale(identifier: "en_US_POSIX")))
    }

    static func compact(_ value: Decimal, symbol: String = "Ksh") -> String {
        "\(symbol) \(plain(value))"
    }

    static func decimal(from text: String) -> Decimal? {
        let normalized = text
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        let isNumeric = normalized.allSatisfy { ("0"..."9").contains($0) || $0 == "." }
        guard !normalized.isEmpty, isNumeric, normalized.filter({ $0 == "." }).count <= 1 else { return nil }
        return Decimal(string: normalized, locale: Locale(identifier: "en_US_POSIX"))
    }
}
