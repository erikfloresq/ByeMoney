//
//  GetTotalSpentIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents
import SwiftUI

/**
 Este intent muestra un SnippetView y usa el nuevo support mode
 */

struct GetTotalSpentIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Total Spent on this month"
    static var description = IntentDescription("Check how much money you've spent in total or this month")
    // deprecated
    //static var openAppWhenRun: Bool =  true

    // Con foreground nos lleva a la app
    static var supportedModes: IntentModes = .background

    func perform() async throws -> some IntentResult & ShowsSnippetView {
        return await .result(
            view: TotalExpenseView()
        )
    }
}

struct TotalExpenseView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.8, blue: 1.0),
                            Color(red: 0.2, green: 0.6, blue: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
                .overlay(
                    VStack(spacing: 20) {
                        Text("You've spent")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)

                        VStack(alignment: .center, spacing: 8) {
                            Text(getTotalExpense())
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)

                            Text("this month")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.bottom, 15)
                        }
                    }
                )
        }
        .padding()
    }

    func getTotalExpense() -> String {
        let total = ExpenseManager.shared.getCurrentMonthTotal()

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "$\(total)"

        return formattedTotal
    }
}

/**
 Intent para obtener el total gastado por periodos
 */

struct GetTotalSpentIntentWithPeriod: AppIntent {
    static var title: LocalizedStringResource = "Get Total Spent"
    static var description = IntentDescription("Check how much money you've spent in total or this month")

    @Parameter(title: "Time Period", default: TimePeriod.thisMonth)
    var timePeriod: TimePeriod

    static var parameterSummary: some ParameterSummary {
        Summary("Get total spent \(\.$timePeriod)")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Double> & ProvidesDialog {
        let total: Double

        switch timePeriod {
        case .thisMonth:
            total = ExpenseManager.shared.getCurrentMonthTotal()
        case .thisWeek:
            total = ExpenseManager.shared.getCurrentWeekTotal()
        case .allTime:
            total = ExpenseManager.shared.getTotalAmount()
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "$\(total)"

        let periodText: String
        switch timePeriod {
        case .thisMonth:
            periodText = "this month"
        case .thisWeek:
            periodText = "this week"
        case .allTime:
            periodText = "in total"
        }

        return .result(
            value: total,
            dialog: "You've spent \(formattedTotal) \(periodText)"
        )
    }
}

