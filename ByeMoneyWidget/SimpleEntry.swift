//
//  SimpleEntry.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalAmount: Double
    let expenseCount: Int
    let status: EntryStatus

    enum EntryStatus {
        case placeholder
        case preview
        case loaded
        case error
    }
}
