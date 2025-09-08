//
//  ExpenseCategoryEnum.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

enum ExpenseCategoryEnum: String, AppEnum {
    case food
    case transport
    case entertainment
    case shopping
    case bills
    case health
    case education
    case other

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Categorias"

    static var caseDisplayRepresentations: [ExpenseCategoryEnum : DisplayRepresentation] = [
        .food: "Comida",
        .transport: "Transporte",
        .entertainment: "Entretenimiento",
        .shopping: "Compras",
        .bills: "Cuentas",
        .health: "Salud",
        .education: "Educación",
        .other: "Otros"
    ]
}
