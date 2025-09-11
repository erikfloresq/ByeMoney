//
//  GetBudgetStatusIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct GetBudgetStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Check Budget Status"
    static var description = IntentDescription("Check your spending against your monthly budget")

    @Parameter(title: "Monthly Budget", default: 2000)
    var monthlyBudget: Double

    static var parameterSummary: some ParameterSummary {
        Summary("Check budget status with \(\.$monthlyBudget) monthly limit")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let totalSpent = ExpenseManager.shared.getCurrentMonthTotal()
        let remaining = monthlyBudget - totalSpent
        let percentageUsed = (totalSpent / monthlyBudget) * 100

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        let spentFormatted = formatter.string(from: NSNumber(value: totalSpent)) ?? "$\(totalSpent)"
        let remainingFormatted = formatter.string(from: NSNumber(value: abs(remaining))) ?? "$\(abs(remaining))"
        let budgetFormatted = formatter.string(from: NSNumber(value: monthlyBudget)) ?? "$\(monthlyBudget)"

        let status: String
        let emoji: String

        if remaining > 0 {
            emoji = percentageUsed < 50 ? "✅" : percentageUsed < 80 ? "⚠️" : "🚨"
            status = "\(emoji) You've spent \(spentFormatted) of your \(budgetFormatted) budget. You have \(remainingFormatted) remaining (\(Int(percentageUsed))% used)."
        } else {
            emoji = "🔴"
            status = "\(emoji) You've exceeded your budget by \(remainingFormatted)! You've spent \(spentFormatted) of your \(budgetFormatted) budget."
        }

        return .result(
            value: status,
            dialog: IntentDialog(stringLiteral: status)
        )
    }
}
