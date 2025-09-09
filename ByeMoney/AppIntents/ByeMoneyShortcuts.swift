//
//  ByeMoneyShortcuts.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 6/9/25.
//

import AppIntents

struct ByeMoneyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            // Open Deeplink with phrases localization
            AppShortcut(
                intent: AddExpenseIntent(),
                phrases: [
                    "Add expense to \(.applicationName)",
                    "Record expense in \(.applicationName)",
                    "Log expense in \(.applicationName)"
                ],
                shortTitle: "Add Expense",
                systemImageName: "plus.circle"
            ),
            // Snippet View with localization
            AppShortcut(
                intent: GetTotalSpentIntent(),
                phrases: [
                    "How much have I spent in \(.applicationName)",
                    "Check spending in \(.applicationName)",
                    "Total expenses in \(.applicationName)",
                    "What's my total in \(.applicationName)"
                ],
                shortTitle: "Total Spent",
                systemImageName: "chart.pie"
            ),
            // Show view with selection
            AppShortcut(
                intent: ShowExpenseIntent(),
                phrases: [
                    "Show expense in \(.applicationName)"
                ],
                shortTitle: "Show expense",
                systemImageName: "list.bullet.circle.fill"
            ),
            // Dialog
            AppShortcut(
                intent: GetBudgetStatusIntent(),
                phrases: [
                    "Check budget in \(.applicationName)",
                    "Budget status in \(.applicationName)",
                    "How's my budget in \(.applicationName)",
                    "Am I within budget in \(.applicationName)"
                ],
                shortTitle: "Budget Status",
                systemImageName: "gauge"
            ),
            AppShortcut(
                intent: GetDailyAverageIntent(),
                phrases: [
                    "Daily average in \(.applicationName)",
                    "Average spending in \(.applicationName)",
                    "How much do I spend per day in \(.applicationName)"
                ],
                shortTitle: "Daily Average",
                systemImageName: "calendar"
            )
        ]
    }
}
