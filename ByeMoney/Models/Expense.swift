//
//  Expense.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Expense {
    var id: UUID
    var amount: Double
    var category: ExpenseCategory
    var notes: String
    var date: Date
    var createdAt: Date

    init(amount: Double, category: ExpenseCategory, notes: String = "", date: Date = Date()) {
        self.id = UUID()
        self.amount = amount
        self.category = category
        self.notes = notes
        self.date = date
        self.createdAt = Date()
    }
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "Comida"
    case transport = "Transporte"
    case entertainment = "Entretenimiento"
    case shopping = "Compras"
    case bills = "Facturas"
    case health = "Salud"
    case education = "Educación"
    case other = "Otros"

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .entertainment: return "tv.fill"
        case .shopping: return "bag.fill"
        case .bills: return "doc.text.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .entertainment: return .purple
        case .shopping: return .pink
        case .bills: return .red
        case .health: return .green
        case .education: return .indigo
        case .other: return .gray
        }
    }
}
