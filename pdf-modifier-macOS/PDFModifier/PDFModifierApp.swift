//
//  PDFModifierApp.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import SwiftUI

@main
struct PDFModifierApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}
