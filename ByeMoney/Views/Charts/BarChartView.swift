//
//  BarChartView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct BarChartView: View {
    let expensesByCategory: [(category: ExpenseCategory, total: Double, percentage: Double)]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Gastos por Categoría")
                .font(.headline)

            Chart(expensesByCategory, id: \.category) { item in
                BarMark(
                    x: .value("Categoría", item.category.rawValue),
                    y: .value("Total", item.total)
                )
                .foregroundStyle(item.category.color.gradient)
                .cornerRadius(6)
                .annotation(position: .top) {
                    VStack(spacing: 2) {
                        Text("$\(item.total, specifier: "%.0f")")
                            .font(.caption2.bold())
                        Text("\(item.percentage, specifier: "%.0f")%")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel(orientation: .vertical)
                        .font(.caption)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }
}
