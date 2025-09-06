//
//  ExpenseListView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct ExpenseListView: View {
    @Query private var expenses: [Expense]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var showingAddExpense = false

    let categoryFilter: ExpenseCategory?
    @Binding var selectedExpenseId: String?

    var filteredExpenses: [Expense] {
        var filtered = expenses

        // Filtro por categoría desde deep link
        if let categoryFilter = categoryFilter {
            filtered = filtered.filter { $0.category == categoryFilter }
        }

        // Filtro por búsqueda
        if !searchText.isEmpty {
            filtered = filtered.filter { expense in
                expense.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                (expense.notes.localizedCaseInsensitiveContains(searchText))
            }
        }

        return filtered.sorted { $0.date > $1.date }
    }

    var totalAmount: Double {
        filteredExpenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack {
            // Header con total
            VStack(spacing: 8) {
                HStack {
                    Text(categoryFilter?.rawValue ?? "Todos los Gastos")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }

                HStack {
                    Text("Total: $\(totalAmount, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.red)
                    Spacer()
                    if categoryFilter != nil {
                        Button("Ver Todos") {
                            DeepLinkManager.shared.navigateToExpenses()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))

            // Lista de gastos
            List {
                ForEach(filteredExpenses) { expense in
                    NavigationLink(
                        destination: ExpenseDetailView(expense: expense),
                        tag: expense.id.uuidString,
                        selection: $selectedExpenseId
                    ) {
                        ExpenseRowView(expense: expense)
                    }
                }
                .onDelete(perform: deleteExpenses)
            }
            .searchable(text: $searchText, prompt: "Buscar gastos...")
        }
        .navigationTitle("ByeMoney")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Compartir Lista") {
                        shareExpensesList()
                    }

                    if let category = categoryFilter {
                        Button("Compartir Categoría") {
                            shareCategory(category)
                        }
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func deleteExpenses(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredExpenses[index])
            }

            // Actualizar widget después de eliminar
            WidgetCenter.reloadByeMoneyWidgetWithDelay()
        }
    }

    private func shareExpensesList() {
        if let url = DeepLinkManager.shared.shareExpenseList() {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        }
    }

    private func shareCategory(_ category: ExpenseCategory) {
        if let url = DeepLinkManager.shared.shareCategory(category) {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
        }
    }
}

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack {
            Image(systemName: expense.category.icon)
                .foregroundColor(expense.category.color)
                .font(.title2)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.category.rawValue)
                    .font(.headline)
                Text(expense.notes.isEmpty ? "Sin notas" : expense.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(expense.amount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(expense.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
