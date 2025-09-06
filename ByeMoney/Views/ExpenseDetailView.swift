//
//  ExpenseDetailView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import SwiftData
import Charts

struct ExpenseDetailView: View {
    let expense: Expense
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: expense.category.icon)
                        .font(.system(size: 60))
                        .foregroundColor(expense.category.color)

                    Text("$\(expense.amount, specifier: "%.2f")")
                        .font(.system(size: 48, weight: .bold, design: .rounded))

                    Text(expense.category.rawValue)
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                // Details Card
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(title: "Fecha", value: expense.date.formatted(date: .complete, time: .omitted))
                    DetailRow(title: "Hora", value: expense.date.formatted(date: .omitted, time: .shortened))

                    if !expense.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notas")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(expense.notes)
                                .font(.body)
                        }
                    }

                    DetailRow(title: "Registrado", value: expense.createdAt.formatted(date: .abbreviated, time: .shortened))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Mini Chart showing this expense vs average
                ExpenseComparisonChart(currentExpense: expense)
                    .frame(height: 200)
                    .padding()

                Spacer(minLength: 50)
            }
        }
        .navigationTitle("Detalle del Gasto")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert("Eliminar Gasto", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                modelContext.delete(expense)
                dismiss()
            }
        } message: {
            Text("¿Estás seguro de que quieres eliminar este gasto?")
        }
    }
}
