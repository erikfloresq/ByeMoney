//
//  DeepLinkDestination.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import Foundation

enum DeepLinkDestination: Equatable {
    case expenses // Lista de gastos
    case charts // Pantalla de gráficos
    case newExpense // Crear nuevo gasto
    case expenseDetail(id: String) // Detalle de un gasto específico
    case category(ExpenseCategory) // Filtrar por categoría
    case none

    static func == (lhs: DeepLinkDestination, rhs: DeepLinkDestination) -> Bool {
        switch (lhs, rhs) {
        case (.expenses, .expenses),
             (.charts, .charts),
             (.newExpense, .newExpense),
             (.none, .none):
            return true
        case (.expenseDetail(let id1), .expenseDetail(let id2)):
            return id1 == id2
        case (.category(let cat1), .category(let cat2)):
            return cat1 == cat2
        default:
            return false
        }
    }
}
