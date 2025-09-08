//
//  Provider.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import WidgetKit
import SwiftData

struct Provider: TimelineProvider {

    // MARK: - TimelineProvider Methods

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalAmount: 0.0, expenseCount: 0, status: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            if context.isPreview {
                // Para previews en Xcode
                let entry = SimpleEntry(
                    date: Date(),
                    totalAmount: 1234.56,
                    expenseCount: 10,
                    status: .preview
                )
                completion(entry)
            } else {
                // Para snapshot real
                let data = await fetchExpenseData()
                let entry = SimpleEntry(
                    date: Date(),
                    totalAmount: data.totalAmount,
                    expenseCount: data.expenseCount,
                    status: .loaded
                )
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            do {
                let data = await fetchExpenseData()

                // Crear entrada actual
                let currentEntry = SimpleEntry(
                    date: Date(),
                    totalAmount: data.totalAmount,
                    expenseCount: data.expenseCount,
                    status: .loaded
                )

                // Crear timeline con política de actualización
                let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()

                let timeline = Timeline(
                    entries: [currentEntry],
                    policy: .after(nextUpdate)
                )

                print("📱 Widget Timeline Updated - Total: $\(data.totalAmount), Count: \(data.expenseCount)")
                completion(timeline)

            } catch {
                print("❌ Widget Timeline Error: \(error)")

                // Crear entrada de error
                let errorEntry = SimpleEntry(
                    date: Date(),
                    totalAmount: 0.0,
                    expenseCount: 0,
                    status: .error
                )

                let timeline = Timeline(
                    entries: [errorEntry],
                    policy: .after(Date().addingTimeInterval(300)) // Reintentar en 5 minutos
                )

                completion(timeline)
            }
        }
    }

    // MARK: - Data Fetching

    private func fetchExpenseData() async -> (totalAmount: Double, expenseCount: Int) {
        do {
            // Usar App Group si está configurado
            let container = try ModelContainer(for: Expense.self, configurations: getModelConfiguration())
            let context = ModelContext(container)

            let descriptor = FetchDescriptor<Expense>()
            let expenses = try context.fetch(descriptor)

            let total = expenses.reduce(0) { $0 + $1.amount }
            let count = expenses.count

            print("📊 Widget Data Fetched - Total: $\(total), Count: \(count)")
            return (totalAmount: total, expenseCount: count)

        } catch {
            print("❌ Widget Data Fetch Error: \(error)")
            return (totalAmount: 0.0, expenseCount: 0)
        }
    }

    private func getModelConfiguration() -> ModelConfiguration {
        // Si usas App Groups, descomenta y configura:
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.erikflores.ByeMoney")?.appendingPathComponent("ByeMoney.sqlite")
        return ModelConfiguration(url: storeURL!)
    }
}
