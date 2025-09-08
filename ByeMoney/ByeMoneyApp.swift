//
//  ByeMoneyApp.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import SwiftData

@main
struct ByeMoneyApp: App {
    let container: ModelContainer
    @StateObject private var deepLinkManager = DeepLinkManager.shared

    init() {
        do {
            let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.erikflores.ByeMoney")?.appendingPathComponent("ByeMoney.sqlite")
            container = try ModelContainer(
                for: Expense.self,
                configurations: ModelConfiguration(url: storeURL!)
            )
        } catch {
            fatalError("Failed to create ModelContainer for Expense")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .environmentObject(deepLinkManager)
                .onOpenURL { url in
                    deepLinkManager.handleURL(url)
                }
        }
    }

    private func getModelConfiguration() -> ModelConfiguration {
        // Si usas App Groups, descomenta y configura:
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.erikflores.ByeMoney")?.appendingPathComponent("ByeMoney.sqlite")
        return ModelConfiguration(url: storeURL!)
    }
}



extension Notification.Name {
    static let openNewExpense = Notification.Name("openNewExpense")
}
