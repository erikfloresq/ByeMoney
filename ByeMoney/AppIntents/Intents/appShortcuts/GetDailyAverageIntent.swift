//
//  GetDailyAverageIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct GetDailyAverageIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Daily Average Spending"
    static var description = IntentDescription("Check your average daily spending")

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Double> & ProvidesDialog {
        let dailyAverage = ExpenseManager.shared.getAverageDailyExpense()

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let formattedAmount = formatter.string(from: NSNumber(value: dailyAverage)) ?? "$\(dailyAverage)"

        return .result(
            value: dailyAverage,
            dialog: "Your average daily spending is \(formattedAmount)"
        )
    }
}
