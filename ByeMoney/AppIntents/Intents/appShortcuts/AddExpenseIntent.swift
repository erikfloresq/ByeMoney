//
//  AddExpenseIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents


/**
  Intent para ejecutar un deeplink y esta registrado en el AppShortcutsProvider para su intregracion con Siri y se muestra en el bundle de atajos
 */
struct AddExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Expense"
    static var description = IntentDescription("Add a new expense to ByeMoney")
    private var deepLinkManager = DeepLinkManager.shared
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        guard let newExpenses = URL(string: "byemoney://expense/new") else {
            throw AppIntentError.restartPerform
        }
        await deepLinkManager.handleURL(newExpenses)
        return .result()
    }
}

/**
  Intent para ejecutar un deeplink con parametros y usando summary
  Este intent no se ven en el bundle de atajos, pero si se ve el listado de shortcuts
 */


struct AddExpenseIntentWithParemeters: AppIntent {
    static var title: LocalizedStringResource = "Add Expense with amount"
    static var description = IntentDescription("Add a new expense to ByeMoney")

    @Parameter(title: "Amount")
    var amount: Double

    @Parameter(title: "Notes")
    var notes: String

    @Parameter(title: "Category")
    var category: ExpenseCategoryEnum?

    static var parameterSummary: some ParameterSummary {
        Summary("Add expense of \(\.$amount) for \(\.$category)") {
            \.$category
        }
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {

        // Crear el gasto usando SwiftData directamente
        let newExpense = Expense(
            amount: amount,
            category: ExpenseCategory(rawValue: category?.rawValue ?? "") ?? .other,
            notes: notes,
            date: Date()
        )

        // Agregar el gasto al contexto
        await ExpenseManager.shared.addExpense(newExpense)

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"

        return .result(
            value: "Added expense: \(formattedAmount) for \(category?.rawValue ?? "")",
            dialog: "I've added your expense of \(formattedAmount) for \(category?.rawValue ?? "")"
        )
    }
}

