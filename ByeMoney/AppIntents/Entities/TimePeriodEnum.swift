//
//  TimePeriod.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 7/9/25.
//

import AppIntents

enum TimePeriod: String, AppEnum {
    case thisMonth = "This Month"
    case thisWeek = "This Week"
    case allTime = "All Time"

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Time Period"
    static var caseDisplayRepresentations: [TimePeriod: DisplayRepresentation] = [
        .thisMonth: "This Month",
        .thisWeek: "This Week",
        .allTime: "All Time"
    ]
}
