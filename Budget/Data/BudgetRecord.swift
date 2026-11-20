//
//  BudgetRecord.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import Foundation
import SwiftData

@Model
final class BudgetRecord {
    var amount: Decimal

    init(amount: Decimal) {
        self.amount = amount
    }
}
