//
//  ContentViews.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import Charts
import SwiftUI
import WidgetKit

struct ContentView: View {
    @StateObject private var deepLinkManager = DeepLinkManager.shared
    @State private var showingAddExpense = false
    @State private var selectedExpenseId: String?
    @State private var categoryFilter: ExpenseCategory?

    var body: some View {
        TabView(selection: $deepLinkManager.selectedTab) {
            // Tab 1: Lista de Gastos
            NavigationStack {
                ExpenseListView(
                    categoryFilter: categoryFilter,
                    selectedExpenseId: $selectedExpenseId
                )
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Gastos")
            }
            .tag(0)

            // Tab 2: Gráficos
            NavigationStack {
                ChartView()
            }
            .tabItem {
                Image(systemName: "chart.pie")
                Text("Gráficos")
            }
            .tag(1)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openNewExpense)) { _ in
            showingAddExpense = true
        }
        .onAppear {
            handleInitialDeepLink()
        }
        .onChange(of: deepLinkManager.destination) { _, newDestination in
            handleDeepLinkDestination(newDestination)
        }
        .onOpenURL { url in
            deepLinkManager.handleURL(url)
        }
    }

    private func handleInitialDeepLink() {
        // Manejar deep link inicial si la app se abrió con uno
        if deepLinkManager.destination != .none {
            handleDeepLinkDestination(deepLinkManager.destination)
        }
    }

    private func handleDeepLinkDestination(_ destination: DeepLinkDestination) {
        switch destination {
        case .expenses:
            categoryFilter = nil

        case .charts:
            // El tab ya se selecciona automáticamente
            break

        case .newExpense:
            showingAddExpense = true

        case .expenseDetail(let id):
            selectedExpenseId = id

        case .category(let category):
            categoryFilter = category

        case .none:
            break
        }
    }
}
