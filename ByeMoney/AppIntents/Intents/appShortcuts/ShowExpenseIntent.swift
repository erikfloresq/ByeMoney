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
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .list: DisplayRepresentation(title: "List", image: .init(named: "ListIcon")),
        .chart: DisplayRepresentation(title: "Charts", image: .init(named: "ChartsIcon"))
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

// MARK: - Intent

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
    var presentation: ExpensePresentationEnum

    func perform() async throws -> some IntentResult {
        switch presentation {
        case .list:
            await deepLinkManager.navigateToExpenses()
        case .chart:
            await deepLinkManager.navigateToCharts()
        }
        return .result()
    }
}

// Nos permite exportar informacion hacia otros shorcuts / intents

extension ShowExpenseIntent: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .plainText) {
            return $0.presentation.rawValue.data(using: .utf8) ?? Data()
        }
    }
}
