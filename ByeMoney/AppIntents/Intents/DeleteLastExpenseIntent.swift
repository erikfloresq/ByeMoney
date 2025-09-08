//
//  DeleteLastExpenseIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct DeleteLastExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Last Expense"
    static var description = IntentDescription("Remove the most recently added expense")

    @Parameter(title: "Confirm Deletion", default: false)
    var confirmDeletion: Bool

    static var parameterSummary: some ParameterSummary {
        When(\.$confirmDeletion, .equalTo, true) {
            Summary("Delete last expense (confirmed)")
        } otherwise: {
            Summary("Delete last expense")
        }
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let recentExpenses = ExpenseManager.shared.getRecentExpenses(limit: 1)

        guard let lastExpense = recentExpenses.first else {
            return .result(dialog: "No expenses to delete")
        }

        guard confirmDeletion else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            let amount = formatter.string(from: NSNumber(value: lastExpense.amount)) ?? "$\(lastExpense.amount)"

            return .result(
                dialog: "Are you sure you want to delete: \(amount) for \(lastExpense.category.rawValue)? Run the shortcut again with confirmation to delete."
            )
        }

        await ExpenseManager.shared.deleteExpense(lastExpense)

        return .result(dialog: "Last expense has been deleted")
    }
}
