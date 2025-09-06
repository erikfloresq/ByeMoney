//
//  WdigetCenter+Extension.swift
//  ByeMoney
//
//  Created by Erik Flores Quispe on 5/9/25.
//

import WidgetKit

extension WidgetCenter {
    static func reloadByeMoneyWidget() {
        print("🔄 Reloading ByeMoney Widget...")
        WidgetCenter.shared.reloadTimelines(ofKind: "ByeMoneyWidget")
    }

    static func reloadByeMoneyWidgetWithDelay() {
        // Agregar un pequeño delay para asegurar que los datos se guardaron
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🔄 Reloading ByeMoney Widget with delay...")
            WidgetCenter.shared.reloadTimelines(ofKind: "ByeMoneyWidget")
        }
    }
}
