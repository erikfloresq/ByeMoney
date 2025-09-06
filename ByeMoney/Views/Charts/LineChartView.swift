//
//  LineChartView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct LineChartView: View {
    let expenses: [Expense]

    var cumulativeExpenses: [(date: Date, cumulative: Double)] {
        let sorted = expenses.sorted { $0.date < $1.date }
        var cumulative = 0.0
        return sorted.map { expense in
            cumulative += expense.amount
            return (date: expense.date, cumulative: cumulative)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Gastos Acumulados")
                .font(.headline)

            if !cumulativeExpenses.isEmpty {
                Chart(cumulativeExpenses, id: \.date) { item in
                    AreaMark(
                        x: .value("Fecha", item.date),
                        y: .value("Acumulado", item.cumulative)
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    LineMark(
                        x: .value("Fecha", item.date),
                        y: .value("Acumulado", item.cumulative)
                    )
                    .foregroundStyle(Color.blue)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5))
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }
}
