//
//  PDFPageThumbnailView.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import SwiftUI
import AppKit

struct PDFPageThumbnailView: View {
    @ObservedObject var pageItem: PDFPageItem
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var thumbnailImage: NSImage?
    @State private var isHovered = false
    
    private let thumbnailSize = CGSize(width: 150, height: 200)
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Thumbnail
                Group {
                    if let image = thumbnailImage {
                        Image(nsImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                            .overlay {
                                ProgressView()
                            }
                    }
                }
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
                )
                .shadow(
                    color: .black.opacity(isHovered ? 0.3 : 0.15),
                    radius: isHovered ? 12 : 6,
                    x: 0,
                    y: isHovered ? 6 : 3
                )
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .padding(3)
                        )
                        .padding(8)
                }
            }
            
            // Page number
            Text("Page \(pageItem.pageNumber)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isHovered ? Color.gray.opacity(0.1) : Color.clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .onTapGesture {
            onTap()
        }
        .onAppear {
            loadThumbnail()
        }
    }
    
    private func loadThumbnail() {
        DispatchQueue.global(qos: .userInitiated).async {
            let image = pageItem.thumbnail(size: thumbnailSize)
            DispatchQueue.main.async {
                self.thumbnailImage = image
            }
        }
    }
}
