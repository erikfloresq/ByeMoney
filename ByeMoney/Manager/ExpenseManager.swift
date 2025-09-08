//
//  ExpenseManager.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class ExpenseManager: ObservableObject {
    static let shared = ExpenseManager()

    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?

    @Published var totalAmount: Double = 0.0
    @Published var expenseCount: Int = 0
    @Published var isLoading: Bool = false

    // Inicialización privada para singleton
    private init() {
        setupModelContainer()
        loadExpenseData()
    }

    // MARK: - Setup Methods

    private func setupModelContainer() {
        do {
            let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.erikflores.ByeMoney")?.appendingPathComponent("ByeMoney.sqlite")
            modelContainer = try ModelContainer(for: Expense.self, configurations: ModelConfiguration(url: storeURL!))
            modelContext = ModelContext(modelContainer!)
        } catch {
            print("Error setting up ModelContainer: \(error)")
        }
    }

    // MARK: - Public Methods

    /// Obtiene el total de todos los gastos
    func getTotalAmount() -> Double {
        return totalAmount
    }

    /// Obtiene la cantidad de gastos registrados
    func getExpenseCount() -> Int {
        return expenseCount
    }

    /// Obtiene el total de gastos por categoría
    func getTotalByCategory(_ category: ExpenseCategory) -> Double {
        guard let context = modelContext else { return 0.0 }

        let descriptor = FetchDescriptor<Expense>(
            predicate: #Predicate { $0.category == category }
        )

        do {
            let expenses = try context.fetch(descriptor)
            return expenses.reduce(0) { $0 + $1.amount }
        } catch {
            print("Error fetching expenses by category: \(error)")
            return 0.0
        }
    }

    /// Obtiene el total de gastos en un rango de fechas
    func getTotalInDateRange(from startDate: Date, to endDate: Date) -> Double {
        guard let context = modelContext else { return 0.0 }

        let descriptor = FetchDescriptor<Expense>(
            predicate: #Predicate { expense in
                expense.date >= startDate && expense.date <= endDate
            }
        )

        do {
            let expenses = try context.fetch(descriptor)
            return expenses.reduce(0) { $0 + $1.amount }
        } catch {
            print("Error fetching expenses in date range: \(error)")
            return 0.0
        }
    }

    /// Obtiene el promedio de gastos diarios
    func getAverageDailyExpense() -> Double {
        guard let _ = modelContext,
              let firstExpenseDate = getFirstExpenseDate() else { return 0.0 }

        let daysSinceFirstExpense = Calendar.current.dateComponents([.day],
                                                                   from: firstExpenseDate,
                                                                   to: Date()).day ?? 1

        return totalAmount / Double(max(daysSinceFirstExpense, 1))
    }

    /// Obtiene los gastos más recientes (últimos N gastos)
    func getRecentExpenses(limit: Int = 5) -> [Expense] {
        guard let context = modelContext else { return [] }

        var descriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = limit

        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching recent expenses: \(error)")
            return []
        }
    }

    /// Obtiene los gastos del mes actual
    func getCurrentMonthTotal() -> Double {
        let calendar = Calendar.current
        let now = Date()

        let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
        let endOfMonth = calendar.dateInterval(of: .month, for: now)?.end ?? now

        return getTotalInDateRange(from: startOfMonth, to: endOfMonth)
    }

    /// Obtiene los gastos de la semana actual
    func getCurrentWeekTotal() -> Double {
        let calendar = Calendar.current
        let now = Date()

        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now

        return getTotalInDateRange(from: startOfWeek, to: endOfWeek)
    }

    /// Recarga los datos de gastos
    func loadExpenseData() {
        Task { @MainActor in
            isLoading = true
            await refreshData()
            isLoading = false
        }
    }

    /// Actualiza los datos después de agregar/eliminar un gasto
    func refreshData() async {
        guard let context = modelContext else { return }

        do {
            let descriptor = FetchDescriptor<Expense>()
            let expenses = try context.fetch(descriptor)

            await MainActor.run {
                self.totalAmount = expenses.reduce(0) { $0 + $1.amount }
                self.expenseCount = expenses.count
            }
        } catch {
            print("Error refreshing expense data: \(error)")
            await MainActor.run {
                self.totalAmount = 0.0
                self.expenseCount = 0
            }
        }
    }

    // MARK: - Private Helpers

    private func getFirstExpenseDate() -> Date? {
        guard let context = modelContext else { return nil }

        var descriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        descriptor.fetchLimit = 1

        do {
            let firstExpense = try context.fetch(descriptor).first
            return firstExpense?.date
        } catch {
            print("Error fetching first expense date: \(error)")
            return nil
        }
    }
}

// MARK: - Extension para uso en Widgets

extension ExpenseManager {
    /// Método específico para widgets que no requiere @MainActor
    static func getWidgetData() async -> (totalAmount: Double, expenseCount: Int) {
        do {
            let container = try ModelContainer(for: Expense.self)
            let context = ModelContext(container)

            let descriptor = FetchDescriptor<Expense>()
            let expenses = try context.fetch(descriptor)

            let total = expenses.reduce(0) { $0 + $1.amount }
            let count = expenses.count

            return (totalAmount: total, expenseCount: count)
        } catch {
            print("Error fetching widget data: \(error)")
            return (totalAmount: 0.0, expenseCount: 0)
        }
    }

    /// Obtiene datos por categoría para widgets
    static func getCategoryDataForWidget() async -> [(category: ExpenseCategory, total: Double)] {
        do {
            let container = try ModelContainer(for: Expense.self)
            let context = ModelContext(container)

            let descriptor = FetchDescriptor<Expense>()
            let expenses = try context.fetch(descriptor)

            let categoryTotals = Dictionary(grouping: expenses, by: { $0.category })
                .mapValues { expenses in
                    expenses.reduce(0) { $0 + $1.amount }
                }
                .map { (category: $0.key, total: $0.value) }
                .sorted { $0.total > $1.total }

            return categoryTotals
        } catch {
            print("Error fetching category data for widget: \(error)")
            return []
        }
    }
}

extension ExpenseManager {

    /// Agrega un nuevo gasto al contexto
    @MainActor
    func addExpense(_ expense: Expense) async {
        guard let context = modelContext else { return }

        context.insert(expense)

        do {
            try context.save()
            await refreshData()
        } catch {
            print("Error saving expense: \(error)")
        }
    }

    /// Elimina un gasto específico
    @MainActor
    func deleteExpense(_ expense: Expense) async {
        guard let context = modelContext else { return }

        context.delete(expense)

        do {
            try context.save()
            await refreshData()
        } catch {
            print("Error deleting expense: \(error)")
        }
    }

    /// Obtiene los totales por categoría ordenados de mayor a menor
    @MainActor
    func getCategoryTotals() async -> [(category: ExpenseCategory, total: Double)] {
        var categoryTotals: [(category: ExpenseCategory, total: Double)] = []

        for category in ExpenseCategory.allCases {
            let total = getTotalByCategory(category)
            if total > 0 {
                categoryTotals.append((category: category, total: total))
            }
        }

        return categoryTotals.sorted { $0.total > $1.total }
    }

    /// Obtiene todos los gastos (para compatibilidad con intents)
    @MainActor
    func getAllExpenses() -> [Expense] {
        guard let context = modelContext else { return [] }

        let descriptor = FetchDescriptor<Expense>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching all expenses: \(error)")
            return []
        }
    }
}
