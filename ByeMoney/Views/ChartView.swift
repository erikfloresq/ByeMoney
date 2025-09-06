//
//  ChartView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct ChartView: View {
    @Query private var expenses: [Expense]
    @State private var selectedTimeRange = TimeRange.month
    @State private var chartType = ChartType.pie

    enum TimeRange: String, CaseIterable {
        case week = "Semana"
        case month = "Mes"
        case year = "Año"
        case all = "Todo"
    }

    enum ChartType: String, CaseIterable {
        case pie = "Circular"
        case bar = "Barras"
        case line = "Líneas"
    }

    var filteredExpenses: [Expense] {
        let now = Date()
        switch selectedTimeRange {
        case .week:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            return expenses.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            return expenses.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now)!
            return expenses.filter { $0.date >= yearAgo }
        case .all:
            return expenses
        }
    }

    var expensesByCategory: [(category: ExpenseCategory, total: Double, percentage: Double)] {
        let grouped = Dictionary(grouping: filteredExpenses, by: { $0.category })
        let totals = grouped.map { (category: $0.key, total: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.total > $1.total }
        let grandTotal = totals.reduce(0) { $0 + $1.total }
        return totals.map { (category: $0.category, total: $0.total, percentage: grandTotal > 0 ? ($0.total / grandTotal) * 100 : 0) }
    }

    var totalAmount: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Picker
                    Picker("Período", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    // Total Card with animation
                    TotalCardView(totalAmount: totalAmount, expenseCount: filteredExpenses.count)

                    if !expensesByCategory.isEmpty {
                        // Chart Type Picker
                        Picker("Tipo de Gráfico", selection: $chartType) {
                            ForEach(ChartType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)

                        // Dynamic Chart based on selection
                        Group {
                            switch chartType {
                            case .pie:
                                PieChartView(expensesByCategory: expensesByCategory)
                            case .bar:
                                BarChartView(expensesByCategory: expensesByCategory)
                            case .line:
                                LineChartView(expenses: filteredExpenses)
                            }
                        }
                        .frame(height: 300)
                        .padding()

                        // Category Breakdown
                        CategoryBreakdownView(expensesByCategory: expensesByCategory, totalAmount: totalAmount)

                        // Additional Charts
                        VStack(spacing: 20) {
                            // Daily Trend Chart
                            DailyTrendChart(expenses: filteredExpenses)
                                .frame(height: 250)
                                .padding(.horizontal)

                            // Weekly Comparison Chart
                            WeeklyComparisonChart(expenses: filteredExpenses)
                                .frame(height: 250)
                                .padding(.horizontal)
                        }
                    } else {
                        EmptyChartView()
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Análisis de Gastos")
            .toolbar {
                ToolbarItem {
                    Button("", systemImage: "square.and.arrow.up") {
                        shareCharts()
                    }
                }
            }
        }
    }

    private func shareCharts() {
        if let url = DeepLinkManager.shared.shareCharts() {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        }
    }
}
