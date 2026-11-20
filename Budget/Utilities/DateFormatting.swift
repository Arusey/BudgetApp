//
//  DateFormatting.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation

enum DateFormatting {
    private static let transactionFormatter = formatter("MMM d, yyyy h:mm a")
    private static let longFormatter = formatter("d MMMM yyyy")
    private static let monthFormatter = formatter("MMMM")

    static func transaction(_ date: Date) -> String {
        transactionFormatter.string(from: date)
    }

    static func long(_ date: Date) -> String {
        longFormatter.string(from: date)
    }

    static func month(_ date: Date) -> String {
        monthFormatter.string(from: date)
    }

    private static func formatter(_ format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = format
        return formatter
    }
}
