//
//  DailyTrendChart.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct DailyTrendChart: View {
    let expenses: [Expense]

    var dailyTotals: [(date: Date, total: Double, dayName: String)] {
        let grouped = Dictionary(grouping: expenses) { expense in
            Calendar.current.startOfDay(for: expense.date)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "es")

        return grouped.map {
            (date: $0.key,
             total: $0.value.reduce(0) { $0 + $1.amount },
             dayName: formatter.string(from: $0.key))
        }
        .sorted { $0.date < $1.date }
        .suffix(7) // Last 7 days
    }

    var averageDaily: Double {
        guard !dailyTotals.isEmpty else { return 0 }
        return dailyTotals.reduce(0) { $0 + $1.total } / Double(dailyTotals.count)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tendencia Diaria")
                    .font(.headline)
                Spacer()
                Text("Promedio: $\(averageDaily, specifier: "%.0f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if !dailyTotals.isEmpty {
                Chart {
                    ForEach(dailyTotals, id: \.date) { item in
                        BarMark(
                            x: .value("Día", item.dayName),
                            y: .value("Total", item.total)
                        )
                        .foregroundStyle(item.total > averageDaily ? Color.red.gradient : Color.green.gradient)
                        .cornerRadius(4)
                    }

                    RuleMark(y: .value("Promedio", averageDaily))
                        .foregroundStyle(.orange)
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        .annotation(position: .top, alignment: .leading) {
                            Text("Promedio")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }
}
