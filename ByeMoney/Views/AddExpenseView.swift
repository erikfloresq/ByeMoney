//
//  AddExpenseView.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var amount = ""
    @State private var selectedCategory = ExpenseCategory.food
    @State private var notes = ""
    @State private var date = Date()
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Información del Gasto") {
                    HStack {
                        Text("$")
                            .font(.title2)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title2)
                    }

                    Picker("Categoría", selection: $selectedCategory) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }

                    DatePicker("Fecha", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Notas (Opcional)") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }

                Section {
                    Button(action: saveExpense) {
                        HStack {
                            Spacer()
                            Text("Guardar Gasto")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("Nuevo Gasto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("Por favor ingresa un monto válido")
            }
        }
    }

    func saveExpense() {
        guard let amountDouble = Double(amount.replacingOccurrences(of: ",", with: ".")),
              amountDouble > 0 else {
            showingAlert = true
            return
        }

        let newExpense = Expense(
            amount: amountDouble,
            category: selectedCategory,
            notes: notes,
            date: date
        )

        modelContext.insert(newExpense)
        WidgetCenter.reloadByeMoneyWidgetWithDelay()
        dismiss()
    }
}
