//
//  CategoryEntity.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct CategoryEntity: AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Category"
    static var defaultQuery = CategoryQuery()

    var id: String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "Categoria")
    }

    static let allCategories: [CategoryEntity] = ExpenseCategory.allCases.map { CategoryEntity(id: $0.rawValue) }
}
