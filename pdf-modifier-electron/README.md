# PDF Editor - Electron App

A beautiful macOS PDF editor built with Electron.js that allows you to manipulate PDF files with ease.

## Features

- 📄 **Upload PDF files** - Select any PDF file from your system
- 👁️ **Preview pages** - View thumbnail previews of all pages
- ➕ **Add pages** - Insert blank pages anywhere in your document
- 🗑️ **Remove pages** - Delete unwanted pages
- 🔄 **Reorder pages** - Drag and drop to rearrange page order
- 💾 **Download edited PDF** - Save your modified PDF file

## Technologies

- **Electron** - Desktop application framework
- **pdf-lib** - PDF manipulation and creation
- **PDF.js** - PDF rendering and preview
- **Modern CSS** - Premium macOS-native design with dark mode

## Installation

```bash
npm install
```

## Development

Run the application in development mode:

```bash
npm start
```

## Building

Build the macOS application:

```bash
npm run build
```

## Usage

1. **Upload a PDF**: Click "Select PDF" or use the file picker
2. **Edit pages**: 
   - Drag and drop pages to reorder them
   - Click the trash icon to delete a page
   - Click "Add Page" to insert a blank page
3. **Download**: Click "Download PDF" to save your edited file

## Project Structure

```
pdf-modifier-electron/
├── main.js          # Electron main process
├── preload.js       # Secure IPC bridge
├── index.html       # Application UI
├── styles.css       # Styling
├── renderer.js      # Application logic
└── package.json     # Dependencies and scripts
```

## License

MIT
