//
//  PDFGridView.swift
//  PDFModifier
//
//  Created on 2025-11-25.
//

import SwiftUI

struct PDFGridView: View {
    @ObservedObject var viewModel: PDFEditorViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 170, maximum: 200), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.pages) { pageItem in
                    PDFPageThumbnailView(
                        pageItem: pageItem,
                        isSelected: viewModel.selectedPageIds.contains(pageItem.id),
                        onTap: {
                            viewModel.toggleSelection(for: pageItem.id)
                        }
                    )
                    .onDrag {
                        // Find the index of this page
                        if let index = viewModel.pages.firstIndex(where: { $0.id == pageItem.id }) {
                            return NSItemProvider(object: String(index) as NSString)
                        }
                        return NSItemProvider()
                    }
                    .onDrop(of: [.text], delegate: DropViewDelegate(
                        destinationItem: pageItem,
                        pages: $viewModel.pages,
                        viewModel: viewModel
                    ))
                }
            }
            .padding(20)
        }
    }
}

// MARK: - Drop Delegate for Reordering
struct DropViewDelegate: DropDelegate {
    let destinationItem: PDFPageItem
    @Binding var pages: [PDFPageItem]
    let viewModel: PDFEditorViewModel
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else {
            return false
        }
        
        itemProvider.loadItem(forTypeIdentifier: "public.text", options: nil) { (item, error) in
            guard let data = item as? Data,
                  let sourceIndexString = String(data: data, encoding: .utf8),
                  let sourceIndex = Int(sourceIndexString),
                  let destinationIndex = pages.firstIndex(where: { $0.id == destinationItem.id })
            else {
                return
            }
            
            DispatchQueue.main.async {
                viewModel.movePages(from: IndexSet(integer: sourceIndex), to: destinationIndex)
            }
        }
        
        return true
    }
}
