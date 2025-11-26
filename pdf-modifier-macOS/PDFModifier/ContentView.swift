//
//  ContentView.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = PDFEditorViewModel()
    @State private var isTargeted = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            toolbar
                .padding()
                .background(Color(NSColor.windowBackgroundColor))
            
            Divider()
            
            // Main content
            ZStack {
                if viewModel.pages.isEmpty {
                    emptyStateView
                } else {
                    PDFGridView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(NSColor.controlBackgroundColor))
        }
        .onDrop(of: [.pdf], isTargeted: $isTargeted) { providers in
            handleDrop(providers: providers)
        }
        .alert("PDF Modifier", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Toolbar
    private var toolbar: some View {
        HStack {
            // Document name
            if !viewModel.documentName.isEmpty {
                Text(viewModel.documentName)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: openPDF) {
                    Label("Open PDF", systemImage: "doc.badge.plus")
                }
                .keyboardShortcut("o", modifiers: .command)
                
                if !viewModel.pages.isEmpty {
                    Button(action: addPages) {
                        Label("Add Pages", systemImage: "plus.rectangle.on.rectangle")
                    }
                    
                    Button(action: viewModel.removeSelectedPages) {
                        Label("Remove Selected", systemImage: "trash")
                    }
                    .disabled(viewModel.selectedPageIds.isEmpty)
                    .keyboardShortcut(.delete, modifiers: [])
                    
                    Button(action: exportPDF) {
                        Label("Export PDF", systemImage: "square.and.arrow.down")
                    }
                    .keyboardShortcut("s", modifiers: .command)
                }
            }
            .buttonStyle(.bordered)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No PDF Loaded")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Drop a PDF file here or click Open PDF to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: openPDF) {
                Label("Open PDF", systemImage: "doc.badge.plus")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(40)
        .frame(maxWidth: 500)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(NSColor.controlBackgroundColor))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isTargeted ? Color.accentColor : Color.clear,
                    lineWidth: 3,
                    antialiased: true
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isTargeted)
    }
    
    // MARK: - Actions
    private func openPDF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                viewModel.loadPDF(from: url)
            }
        }
    }
    
    private func addPages() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.pdf]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.message = "Select a PDF to add pages from"
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                viewModel.addPagesFromPDF(url: url)
            }
        }
    }
    
    private func exportPDF() {
        viewModel.exportPDF { url in
            if let url = url {
                alertMessage = "PDF exported successfully to:\n\(url.path)"
            } else {
                alertMessage = "Failed to export PDF"
            }
            showingAlert = true
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        
        provider.loadItem(forTypeIdentifier: UTType.pdf.identifier, options: nil) { (item, error) in
            guard let url = item as? URL else { return }
            
            DispatchQueue.main.async {
                viewModel.loadPDF(from: url)
            }
        }
        
        return true
    }
}

#Preview {
    ContentView()
        .frame(width: 900, height: 700)
}
