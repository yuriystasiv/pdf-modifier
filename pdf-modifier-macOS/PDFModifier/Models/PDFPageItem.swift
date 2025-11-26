//
//  PDFPageItem.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import Foundation
import PDFKit
import AppKit

/// Identifiable wrapper for PDFPage to work with SwiftUI
class PDFPageItem: Identifiable, ObservableObject {
    let id = UUID()
    let page: PDFPage
    let pageNumber: Int
    @Published var isSelected: Bool = false
    
    init(page: PDFPage, pageNumber: Int) {
        self.page = page
        self.pageNumber = pageNumber
    }
    
    /// Generate thumbnail image for the page
    func thumbnail(size: CGSize) -> NSImage {
        let bounds = page.bounds(for: .mediaBox)
        let scale = min(size.width / bounds.width, size.height / bounds.height)
        let scaledSize = CGSize(width: bounds.width * scale, height: bounds.height * scale)
        
        return NSImage(size: scaledSize, flipped: false) { rect in
            guard let context = NSGraphicsContext.current?.cgContext else { return false }
            
            context.saveGState()
            context.setFillColor(NSColor.white.cgColor)
            context.fill(rect)
            
            let transform = self.page.transform(for: .mediaBox)
            context.scaleBy(x: scale, y: scale)
            context.concatenate(transform)
            
            self.page.draw(with: .mediaBox, to: context)
            context.restoreGState()
            
            return true
        }
    }
}
