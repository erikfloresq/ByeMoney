//
//  PieChartView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct PieChartView: View {
    let expensesByCategory: [(category: ExpenseCategory, total: Double, percentage: Double)]
    @State private var selectedSlice: ExpenseCategory?

    var body: some View {
        VStack {
            Text("Distribución por Categoría")
                .font(.headline)

            Chart(expensesByCategory, id: \.category) { item in
                SectorMark(
                    angle: .value("Total", item.total),
                    innerRadius: .ratio(0.5),
                    outerRadius: selectedSlice == item.category ? .ratio(1.0) : .ratio(0.95),
                    angularInset: 1.5
                )
                .foregroundStyle(item.category.color.gradient)
                .cornerRadius(5)
                .opacity(selectedSlice == nil || selectedSlice == item.category ? 1.0 : 0.5)
            }
            .chartAngleSelection(value: .constant(0))
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry.frame(in: .local)
                    VStack {
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(expensesByCategory.reduce(0) { $0 + $1.total }, specifier: "%.0f")")
                            .font(.title2.bold())
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }
}
