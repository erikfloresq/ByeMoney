//
//  GetRecentExpensesIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct ExpenseDetailEntity: IndexedEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Last expenses")
    var displayRepresentation: DisplayRepresentation  {
        DisplayRepresentation(title: "\(createdAt)")
    }

    @ComputedProperty
    var id: String { expense.id.uuidString }

    @ComputedProperty(indexingKey: \.contentDescription)
    var notes: String { expense.notes }

    var createdAt: String {
        expense.createdAt.formatted(date: .abbreviated, time: .shortened)
    }

    let expense: Expense

    static var defaultQuery = ExpenseDetailQuery()
}

struct ExpenseDetailQuery: EntityQuery {

    func entities(for identifiers: [String]) async throws -> [ExpenseDetailEntity] {
        let recentExpenses = await ExpenseManager.shared.getRecentExpenses(limit: 5)
        return recentExpenses.map { ExpenseDetailEntity(expense: $0) }
    }

    func suggestedEntities() async throws -> [ExpenseDetailEntity] {
        let recentExpenses = await ExpenseManager.shared.getRecentExpenses(limit: 3)
        return recentExpenses.map { ExpenseDetailEntity(expense: $0) }
    }
}

struct GetLastExpensesIntent: AppIntent, TargetContentProvidingIntent {
    static var title: LocalizedStringResource = "Get last Expenses"
    static var description = IntentDescription("View your most recent expenses")
    static var openAppWhenRun: Bool = true
    private var deepLinkManager = DeepLinkManager.shared

    @Parameter(title: "Expense", requestValueDialog: "Which expense?")
    var lastExpense: ExpenseDetailEntity

    @MainActor
    func perform() async throws -> some IntentResult {
        guard let url = URL(string: "byemoney://expense/\(lastExpense.id)") else {
            throw AppIntentError.restartPerform
        }
        deepLinkManager.handleURL(url)
        return .result()
    }
}

struct GetRecentExpensesIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Recent Expenses"
    static var description = IntentDescription("View your most recent expenses")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Number of Expenses", default: 5, inclusiveRange: (1, 10))
    var count: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Show last \(\.$count) expenses")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog & OpensIntent {
        let recentExpenses = ExpenseManager.shared.getRecentExpenses(limit: count)

        guard !recentExpenses.isEmpty else {
            return .result(
                value: "No expenses found",
                dialog: "You haven't recorded any expenses yet"
            )
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        let expenseList = recentExpenses.map { expense in
            let amount = formatter.string(from: NSNumber(value: expense.amount)) ?? "$\(expense.amount)"
            let date = dateFormatter.string(from: expense.date)
            return "\(expense.category.rawValue) \(amount) - \(expense.notes) (\(date))"
        }.joined(separator: "\n")

        return .result(
            value: expenseList,
            dialog: "Here are your last \(recentExpenses.count) expenses:\n\(expenseList)"
        )
    }
}
