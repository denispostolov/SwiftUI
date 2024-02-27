//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Denis Postolov on 22/02/24.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    // generates automatically the id field of an ExpenseItem
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
