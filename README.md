# PDF Modifier

A collection of PDF editing applications that allow users to upload, modify, and download PDF files. This repository contains three different implementations to suit different use cases.

## 🎯 Features

All implementations provide the following core functionality:

- **Upload PDFs**: Load PDF documents via file picker or drag-and-drop
- **Page Preview**: View all pages as thumbnails in a responsive grid
- **Remove Pages**: Delete unwanted pages with multi-selection support
- **Reorder Pages**: Rearrange pages using drag-and-drop
- **Add Pages**: Insert pages from other PDF files
- **Export**: Download the modified PDF with all changes preserved

## 📦 Implementations

This repository contains three different implementations of the PDF modifier:

### 1. Web Application (`pdf-modifier-web`)

A modern web application built with Nuxt.js for browser-based PDF editing.

**Technology Stack:**

- Nuxt.js 4.x
- Vue 3 with Composition API
- TypeScript
- pdf-lib (PDF manipulation)
- pdfjs-dist (PDF rendering)

**Setup:**

```bash
cd pdf-modifier-web
npm install
npm run dev
```

The application will be available at `http://localhost:3000`

**Build for Production:**

```bash
npm run build
npm run preview
```

### 2. Electron Desktop App (`pdf-modifier-electron`)

A cross-platform desktop application built with Electron for macOS, Windows, and Linux.

**Technology Stack:**

- Electron 28.x
- pdf-lib (PDF manipulation)
- pdfjs-dist (PDF rendering)
- HTML/CSS/JavaScript

**Setup:**

```bash
cd pdf-modifier-electron
npm install
npm run dev
```

**Build for macOS:**

```bash
npm run build
```

This creates a distributable `.dmg` and `.zip` file in the `dist` folder.

### 3. Native macOS App (`pdf-modifier-macOS`)

A native macOS application built with Swift and SwiftUI for optimal performance and integration.

**Technology Stack:**

- Swift
- SwiftUI
- PDFKit (Apple's native PDF framework)
- AppKit

**Requirements:**

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later

**Setup:**

```bash
cd pdf-modifier-macOS
open PDFModifier.xcodeproj
```

Press `⌘R` in Xcode to build and run.

**Build from Command Line:**

```bash
xcodebuild -project PDFModifier.xcodeproj -scheme PDFModifier -configuration Debug build
```

## 🚀 Quick Start

Choose the implementation that best fits your needs:

- **Web App**: Best for browser-based usage, no installation required
- **Electron App**: Best for cross-platform desktop application with consistent UI
- **Native macOS App**: Best for macOS users who want optimal performance and native integration

## 📝 Usage

All implementations follow a similar workflow:

1. **Open a PDF**: Click "Open PDF" or drag a PDF file into the window
2. **Edit Pages**:
   - Click on thumbnails to select pages (hold Cmd/Ctrl for multi-select)
   - Drag thumbnails to reorder pages
   - Click "Remove Selected" or press Delete to remove pages
   - Click "Add Pages" to insert pages from another PDF
3. **Export**: Click "Export PDF" or "Download" to save your changes

## 🏗️ Architecture

Each implementation follows best practices for its respective platform:

- **Web App**: Nuxt.js with Vue 3 Composition API and TypeScript
- **Electron App**: Main process (Node.js) + Renderer process (web technologies)
- **Native macOS App**: MVVM pattern with SwiftUI and PDFKit

## 🔒 Security

- All PDF processing happens client-side (no server uploads)
- Input sanitization and validation
- Secure file handling
- No data persistence (privacy-focused)

## 📄 License

Copyright © 2025. All rights reserved.

## 🤝 Contributing

Each implementation is self-contained in its respective directory. Please refer to the individual README files for implementation-specific details.
