//
//  CategoryBreakdownView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct CategoryBreakdownView: View {
    let expensesByCategory: [(category: ExpenseCategory, total: Double, percentage: Double)]
    let totalAmount: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Desglose Detallado")
                .font(.headline)
                .padding(.horizontal)

            ForEach(expensesByCategory, id: \.category) { item in
                HStack {
                    Image(systemName: item.category.icon)
                        .foregroundColor(item.category.color)
                        .frame(width: 30)

                    Text(item.category.rawValue)
                        .font(.body)

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("$\(item.total, specifier: "%.2f")")
                            .font(.headline)
                        Text("\(item.percentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    GeometryReader { geometry in
                        HStack {
                            Rectangle()
                                .fill(item.category.color.opacity(0.3))
                                .frame(width: geometry.size.width * (item.percentage / 100))
                            Spacer()
                        }
                        .cornerRadius(8)
                    }
                )
            }
            .padding(.horizontal)
        }
    }
}
