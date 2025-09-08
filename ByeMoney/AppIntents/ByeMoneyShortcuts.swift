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
            AppShortcut(
                intent: GetTopCategoryIntent(),
                phrases: [
                    "Where do I spend the most in \(.applicationName)",
                    "Top category in \(.applicationName)",
                    "Biggest expense category in \(.applicationName)",
                    "What's my highest spending category in \(.applicationName)"
                ],
                shortTitle: "Top Category",
                systemImageName: "chart.bar"
            ),
            AppShortcut(
                intent: GetRecentExpensesIntent(),
                phrases: [
                    "Show recent expenses in \(.applicationName)",
                    "Latest expenses in \(.applicationName)",
                    "What did I buy recently in \(.applicationName)"
                ],
                shortTitle: "Recent Expenses",
                systemImageName: "clock"
            ),
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
