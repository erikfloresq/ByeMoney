//
//  ExpenseComparisonChart.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts
import SwiftData

struct ExpenseComparisonChart: View {
    let currentExpense: Expense
    @Query private var allExpenses: [Expense]

    var averageByCategory: Double {
        let categoryExpenses = allExpenses.filter { $0.category == currentExpense.category }
        guard !categoryExpenses.isEmpty else { return 0 }
        return categoryExpenses.reduce(0) { $0 + $1.amount } / Double(categoryExpenses.count)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Comparación con promedio")
                .font(.headline)
                .padding(.horizontal)

            Chart {
                BarMark(
                    x: .value("Tipo", "Este gasto"),
                    y: .value("Monto", currentExpense.amount)
                )
                .foregroundStyle(currentExpense.category.color)

                BarMark(
                    x: .value("Tipo", "Promedio \(currentExpense.category.rawValue)"),
                    y: .value("Monto", averageByCategory)
                )
                .foregroundStyle(Color.gray.opacity(0.5))
            }
            .padding()
        }
    }
}

