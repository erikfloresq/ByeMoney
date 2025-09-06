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
            container = try ModelContainer(for: Expense.self)
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
}

extension Notification.Name {
    static let openNewExpense = Notification.Name("openNewExpense")
}
