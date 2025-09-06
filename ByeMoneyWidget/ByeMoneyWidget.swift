//
//  ByeMoneyWidget.swift
//  ByeMoneyWidget
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import WidgetKit
import SwiftUI

struct ByeMoneyWidget: Widget {
    let kind: String = "ByeMoneyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ByeMoneyWidgetView(entry: entry)
        }
        .configurationDisplayName("ByeMoney")
        .description("Visualiza tus gastos totales y el número de transacciones registradas.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled() // iOS 17+
    }
}

struct ByeMoneyWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red)
                Text("ByeMoney")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }

            Spacer()

            // Content based on status
            switch entry.status {
            case .placeholder:
                PlaceholderContent()
            case .error:
                ErrorContent()
            case .preview, .loaded:
                LoadedContent(entry: entry)
            }

            Spacer()
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        HStack(spacing: 16) {
            // Left side - Icon and title
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red)
                    Text("ByeMoney")
                        .font(.headline)
                        .fontWeight(.semibold)
                }

                Spacer()

                Text("Gastos Totales")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Right side - Data
            VStack(alignment: .trailing, spacing: 4) {
                switch entry.status {
                case .placeholder:
                    Text("$---.--")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .redacted(reason: .placeholder)

                    Text("-- gastos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .redacted(reason: .placeholder)

                case .error:
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title)
                        .foregroundColor(.orange)

                    Text("Error")
                        .font(.caption)
                        .foregroundColor(.secondary)

                case .preview, .loaded:
                    Text("$\(entry.totalAmount, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)

                    Text("\(entry.expenseCount) gastos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Actualizado: \(entry.date, format: .dateTime.hour().minute())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

// MARK: - Content Views

struct PlaceholderContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Total Gastado")
                .font(.caption2)
                .foregroundColor(.secondary)
                .redacted(reason: .placeholder)

            Text("$---.--")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .redacted(reason: .placeholder)

            Text("-- gastos")
                .font(.caption2)
                .foregroundColor(.secondary)
                .redacted(reason: .placeholder)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ErrorContent: View {
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundColor(.orange)

            Text("Sin datos")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct LoadedContent: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Total Gastado")
                .font(.caption2)
                .foregroundColor(.secondary)

            Text("$\(entry.totalAmount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.red)

            Text("\(entry.expenseCount) gastos")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

