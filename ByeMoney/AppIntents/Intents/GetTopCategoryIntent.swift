//
//  GetTopCategoryIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct GetTopCategoryIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Top Spending Category"
    static var description = IntentDescription("Find out which category you spend the most money on")

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let categoryData = await ExpenseManager.shared.getCategoryTotals()

        guard let topCategory = categoryData.first else {
            return .result(
                value: "No expenses found",
                dialog: "You haven't recorded any expenses yet"
            )
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let formattedAmount = formatter.string(from: NSNumber(value: topCategory.total)) ?? "$\(topCategory.total)"

        return .result(
            value: topCategory.category.rawValue,
            dialog: "Your highest spending category is \(topCategory.category.rawValue) with \(formattedAmount) spent"
        )
    }
}
