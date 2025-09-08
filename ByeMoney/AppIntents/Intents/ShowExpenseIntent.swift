//
//  ShowExpenseIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents
import CoreTransferable
internal import UniformTypeIdentifiers

enum ExpensePresentationEnum: String, AppEnum {
    case list = "List"
    case chart = "Charts"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Presentation"
    static var caseDisplayRepresentations: [ExpensePresentationEnum: DisplayRepresentation] = [
        .list: "List",
        .chart: "Charts"
    ]
}


struct ExpensePresentationEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Presentation"
    static var defaultQuery = PresentationQuery()
    var id: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(id)",
            subtitle: "Show expenses in \(id)",
            image: .init(named: "\(id)Icon")
        )
    }
}

struct PresentationQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [ExpensePresentationEntity] {
        ExpensePresentationEnum.allCases.map {
            ExpensePresentationEntity(id: $0.rawValue)
        }
    }

    func suggestedEntities() async throws -> [ExpensePresentationEntity] {
        ExpensePresentationEnum.allCases.map {
            ExpensePresentationEntity(id: $0.rawValue)
        }
    }
}

struct ShowExpenseIntent: AppIntent {
    static var title: LocalizedStringResource = "Show expenses"
    static var description: IntentDescription? = "Show expense with differents presentations"
    private var deepLinkManager = DeepLinkManager.shared
    static var supportedModes: IntentModes = .foreground
    static var parameterSummary: some ParameterSummary {
        Summary("Show my expenses by \(\.$presentation)")
    }

     // Nos permite inyectar modelos desde el inicio de la app
     //@Dependecy var modelData: ModelData

    @Parameter(title: "Presentation")
    var presentation: ExpensePresentationEntity

    func perform() async throws -> some IntentResult {
        if presentation.id == "List" {
            await deepLinkManager.navigateToExpenses()
        }
        if presentation.id == "Charts" {
            await deepLinkManager.navigateToCharts()
        }
        return .result()
    }
}

// Nos permite exportar informacion hacia otros shorcuts / intents

extension ShowExpenseIntent: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .text) {
            return $0.presentation.id.data(using: .utf8) ?? Data()
        }
    }
}
