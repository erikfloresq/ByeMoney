//
//  CategoryQuery.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

struct CategoryQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [CategoryEntity] {
        CategoryEntity.allCategories.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [CategoryEntity] {
        CategoryEntity.allCategories
    }
}
