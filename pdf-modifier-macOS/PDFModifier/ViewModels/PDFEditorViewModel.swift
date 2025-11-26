//
//  PDFEditorViewModel.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import Foundation
import PDFKit
import SwiftUI
import UniformTypeIdentifiers

class PDFEditorViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var pages: [PDFPageItem] = []
    @Published var selectedPageIds: Set<UUID> = []
    @Published var documentName: String = ""
    
    /// Load a PDF from a URL
    func loadPDF(from url: URL) {
        guard let document = PDFDocument(url: url) else {
            print("Failed to load PDF from \(url)")
            return
        }
        
        self.pdfDocument = document
        self.documentName = url.deletingPathExtension().lastPathComponent
        self.reloadPages()
    }
    
    /// Reload pages from the current document
    private func reloadPages() {
        guard let document = pdfDocument else {
            pages = []
            return
        }
        
        pages = document.allPages().enumerated().map { index, page in
            PDFPageItem(page: page, pageNumber: index + 1)
        }
    }
    
    /// Remove selected pages
    func removeSelectedPages() {
        let indicesToRemove = IndexSet(
            pages.enumerated()
                .filter { selectedPageIds.contains($0.element.id) }
                .map { $0.offset }
        )
        
        guard !indicesToRemove.isEmpty else { return }
        
        pdfDocument?.removePages(at: indicesToRemove)
        selectedPageIds.removeAll()
        reloadPages()
    }
    
    /// Move pages from source indices to destination index
    func movePages(from source: IndexSet, to destination: Int) {
        var updatedPages = pages
        updatedPages.move(fromOffsets: source, toOffset: destination)
        
        // Create new document with reordered pages
        let reorderedPDFPages = updatedPages.map { $0.page }
        if let newDocument = PDFDocument.create(from: reorderedPDFPages) as PDFDocument? {
            self.pdfDocument = newDocument
            reloadPages()
        }
    }
    
    /// Add pages from another PDF
    func addPagesFromPDF(url: URL) {
        guard let sourcePDF = PDFDocument(url: url),
              let currentDocument = pdfDocument else {
            return
        }
        
        let currentPageCount = currentDocument.pageCount
        
        for i in 0..<sourcePDF.pageCount {
            if let page = sourcePDF.page(at: i) {
                currentDocument.insert(page, at: currentPageCount + i)
            }
        }
        
        reloadPages()
    }
    
    /// Export the modified PDF
    func exportPDF(completion: @escaping (URL?) -> Void) {
        guard let document = pdfDocument else {
            completion(nil)
            return
        }
        
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.pdf]
        savePanel.nameFieldStringValue = "\(documentName)_edited.pdf"
        savePanel.canCreateDirectories = true
        
        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                if document.write(to: url) {
                    completion(url)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    /// Toggle selection for a page
    func toggleSelection(for pageId: UUID) {
        if selectedPageIds.contains(pageId) {
            selectedPageIds.remove(pageId)
        } else {
            selectedPageIds.insert(pageId)
        }
    }
    
    /// Clear all selections
    func clearSelection() {
        selectedPageIds.removeAll()
    }
}
