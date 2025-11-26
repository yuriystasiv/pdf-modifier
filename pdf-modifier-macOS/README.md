# PDF Modifier

A native macOS application for editing PDF files with an intuitive interface.

## Features

- **Upload PDFs**: Drag-and-drop or use the file picker to load PDF documents
- **Page Management**:
  - View all pages as thumbnails in a responsive grid
  - Remove unwanted pages with multi-selection support
  - Reorder pages using drag-and-drop
  - Add pages from other PDF files
- **Export**: Save your modified PDF with all changes preserved
- **Modern UI**: Built with SwiftUI featuring smooth animations and hover effects

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later

## Building and Running

1. Open `PDFModifier.xcodeproj` in Xcode
2. Select the PDFModifier scheme
3. Press ⌘R to build and run the application

Alternatively, build from the command line:

```bash
xcodebuild -project PDFModifier.xcodeproj -scheme PDFModifier -configuration Debug build
```

## Usage

1. **Open a PDF**: Click "Open PDF" or drag a PDF file into the window
2. **Edit Pages**:
   - Click on thumbnails to select pages (hold ⌘ for multi-select)
   - Drag thumbnails to reorder pages
   - Click "Remove Selected" or press Delete to remove pages
   - Click "Add Pages" to insert pages from another PDF
3. **Export**: Click "Export PDF" or press ⌘S to save your changes

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **Models**: `PDFPageItem`, `PDFDocument+Extensions`
- **Views**: `ContentView`, `PDFGridView`, `PDFPageThumbnailView`
- **ViewModels**: `PDFEditorViewModel`

## Technology Stack

- **Swift**: Primary programming language
- **SwiftUI**: Modern declarative UI framework
- **PDFKit**: Apple's framework for PDF manipulation
- **AppKit**: For native macOS integration

## License

Copyright © 2025. All rights reserved.
