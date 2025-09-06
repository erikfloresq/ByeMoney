//
//  TotalCardView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import Charts

struct TotalCardView: View {
    let totalAmount: Double
    let expenseCount: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Total Gastado")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("$\(totalAmount, specifier: "%.2f")")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(.red)
                .contentTransition(.numericText())
            Text("\(expenseCount) gastos")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
