//
//  PDFDocument+Extensions.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import Foundation
import PDFKit

extension PDFDocument {
    /// Create a new PDF document from an array of pages
    static func create(from pages: [PDFPage]) -> PDFDocument {
        let document = PDFDocument()
        
        for (index, page) in pages.enumerated() {
            document.insert(page, at: index)
        }
        
        return document
    }
    
    /// Get all pages as an array
    func allPages() -> [PDFPage] {
        var pages: [PDFPage] = []
        for i in 0..<pageCount {
            if let page = page(at: i) {
                pages.append(page)
            }
        }
        return pages
    }
    
    /// Remove pages at specified indices
    func removePages(at indices: IndexSet) {
        // Remove in reverse order to maintain correct indices
        for index in indices.sorted(by: >) {
            if index < pageCount {
                removePage(at: index)
            }
        }
    }
}
