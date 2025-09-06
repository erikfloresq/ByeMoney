//
//  WeeklyComparisonChart.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct WeeklyComparisonChart: View {
    let expenses: [Expense]

    var weeklyData: [(week: String, total: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: expenses) { expense in
            calendar.dateInterval(of: .weekOfYear, for: expense.date)?.start ?? expense.date
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = Locale(identifier: "es")

        return Array(
            grouped.map {
                (week: "Sem. \(formatter.string(from: $0.key))",
                 total: $0.value.reduce(0) { $0 + $1.amount })
            }
            .sorted { $0.total > $1.total }
            .prefix(4)
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Comparación Semanal")
                .font(.headline)

            if !weeklyData.isEmpty {
                Chart(weeklyData, id: \.week) { item in
                    BarMark(
                        x: .value("Total", item.total),
                        y: .value("Semana", item.week)
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: [Color.purple, Color.pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(6)
                    .annotation(position: .trailing) {
                        Text("$\(item.total, specifier: "%.0f")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
            }
        }
    }
}
