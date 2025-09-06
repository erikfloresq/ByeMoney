//
//  DeepLinkManager.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import Foundation
import Combine

/**
 Deeplinks list

 byemoney://expenses
 byemoney://charts
 byemoney://expense/new
 byemoney://expense/{id}
 byemoney://category/Comida
 byemoney://category/Transporte
 byemoney://category/Entretenimiento
 */

@MainActor
class DeepLinkManager: ObservableObject {
    @Published var destination: DeepLinkDestination = .none
    @Published var selectedTab: Int = 0

    static let shared = DeepLinkManager()

    private init() {}

    // MARK: - URL Handling

    func handleURL(_ url: URL) {
        guard url.scheme == "byemoney" else {
            print("❌ Invalid scheme: \(url.scheme ?? "none")")
            return
        }

        print("🔗 Processing deep link: \(url.absoluteString)")

        switch url.host {
        case "expenses":
            handleExpensesDeepLink(url)
        case "charts", "analytics":
            handleChartsDeepLink(url)
        case "expense":
            handleExpenseDeepLink(url)
        case "category":
            handleCategoryDeepLink(url)
        default:
            print("❌ Unknown deep link host: \(url.host ?? "none")")
            destination = .none
        }
    }

    // MARK: - Specific Handlers

    private func handleExpensesDeepLink(_ url: URL) {
        selectedTab = 0 // Tab de gastos
        destination = .expenses
        print("🎯 Navigating to expenses list")
    }

    private func handleChartsDeepLink(_ url: URL) {
        selectedTab = 1 // Tab de gráficos
        destination = .charts
        print("🎯 Navigating to charts")
    }

    private func handleExpenseDeepLink(_ url: URL) {
        let pathComponents = url.pathComponents

        if pathComponents.contains("new") {
            // byemoney://expense/new
            selectedTab = 0
            destination = .newExpense
            print("🎯 Navigating to new expense")
        } else if pathComponents.count > 1 {
            // byemoney://expense/{id}
            let expenseId = pathComponents[1]
            selectedTab = 0
            destination = .expenseDetail(id: expenseId)
            print("🎯 Navigating to expense detail: \(expenseId)")
        } else {
            // byemoney://expense (default to expenses list)
            selectedTab = 0
            destination = .expenses
            print("🎯 Navigating to expenses list (default)")
        }
    }

    private func handleCategoryDeepLink(_ url: URL) {
        let pathComponents = url.pathComponents

        if pathComponents.count > 1 {
            let categoryString = pathComponents[1]
            if let category = ExpenseCategory.allCases.first(where: {
                $0.rawValue.lowercased() == categoryString.lowercased()
            }) {
                selectedTab = 0
                destination = .category(category)
                print("🎯 Navigating to category: \(category.rawValue)")
            } else {
                print("❌ Unknown category: \(categoryString)")
                destination = .expenses
            }
        } else {
            selectedTab = 0
            destination = .expenses
        }
    }

    // MARK: - URL Generation

    static func createURL(for destination: DeepLinkDestination) -> URL? {
        let baseURL = "byemoney://"

        switch destination {
        case .expenses:
            return URL(string: "\(baseURL)expenses")
        case .charts:
            return URL(string: "\(baseURL)charts")
        case .newExpense:
            return URL(string: "\(baseURL)expense/new")
        case .expenseDetail(let id):
            return URL(string: "\(baseURL)expense/\(id)")
        case .category(let category):
            return URL(string: "\(baseURL)category/\(category.rawValue)")
        case .none:
            return nil
        }
    }

    // MARK: - Navigation Helpers

    func navigateToExpenses() {
        selectedTab = 0
        destination = .expenses
    }

    func navigateToCharts() {
        selectedTab = 1
        destination = .charts
    }

    func navigateToNewExpense() {
        selectedTab = 0
        destination = .newExpense
    }

    func clearDestination() {
        destination = .none
    }
}

// MARK: - Deep Link Extensions

extension DeepLinkManager {

    // Para compartir URLs
    func shareExpenseList() -> URL? {
        return Self.createURL(for: .expenses)
    }

    func shareCharts() -> URL? {
        return Self.createURL(for: .charts)
    }

    func shareExpense(id: String) -> URL? {
        return Self.createURL(for: .expenseDetail(id: id))
    }

    func shareCategory(_ category: ExpenseCategory) -> URL? {
        return Self.createURL(for: .category(category))
    }
}
