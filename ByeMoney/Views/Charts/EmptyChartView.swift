//
//  EmptyChartView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI

struct EmptyChartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.pie")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.3))
            Text("No hay gastos registrados")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Agrega tu primer gasto para ver análisis")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.top, 50)
    }
}
