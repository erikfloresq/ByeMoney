//
//  AuthenticationIntent.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 10/9/25.
//

import AppIntents

struct AuthenticationIntent: AppIntent {
    static var title: LocalizedStringResource = "Authenticate User"
    static var description = IntentDescription("Authenticates the user with the specified method")

    // Nos permite ocultar el intent para uso interno
    static var isDiscoverable: Bool  = false


    func perform() async throws -> some IntentResult {
        return .result()
    }
}
