# PDF Modifier

A modern, browser-based PDF editor built with Nuxt.js that allows you to upload, modify, and download PDF files with ease.

## ✨ Features

- **📤 Upload PDF Files** - Drag and drop or select PDF files from your device
- **👁️ Preview Pages** - View all pages of your PDF in a grid layout
- **🗑️ Remove Pages** - Delete unwanted pages from your PDF
- **🔄 Reorder Pages** - Rearrange pages using drag-and-drop or arrow buttons
- **➕ Add Blank Pages** - Insert new blank pages into your document
- **💾 Download Modified PDF** - Export your edited PDF file
- **🔒 Client-Side Processing** - All PDF operations happen in your browser for privacy and security

## 🛠️ Tech Stack

- **[Nuxt.js 4](https://nuxt.com/)** - Vue.js framework for building web applications
- **[Vue 3](https://vuejs.org/)** - Progressive JavaScript framework
- **[TypeScript](https://www.typescriptlang.org/)** - Type-safe JavaScript
- **[PDF.js](https://mozilla.github.io/pdf.js/)** - PDF rendering library by Mozilla
- **[pdf-lib](https://pdf-lib.js.org/)** - PDF manipulation library
- **Vanilla CSS** - Custom styling for a clean, modern interface

## 📋 Prerequisites

- Node.js 18.x or higher
- npm, pnpm, yarn, or bun package manager

## 🚀 Getting Started

### Installation

Clone the repository and install dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

### Development Server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm dev

# yarn
yarn dev

# bun
bun run dev
```

### Production Build

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm build

# yarn
yarn build

# bun
bun run build
```

Preview the production build locally:

```bash
# npm
npm run preview

# pnpm
pnpm preview

# yarn
yarn preview

# bun
bun run preview
```

## 📖 Usage

1. **Upload a PDF**: Click the "Upload PDF" button and select a PDF file from your device
2. **View Pages**: All pages will be displayed in a grid layout with thumbnails
3. **Modify Pages**:
   - **Delete**: Click the delete button on any page to remove it
   - **Reorder**: Drag and drop pages or use the arrow buttons to rearrange them
   - **Add Blank Page**: Click "Add Blank Page" to insert a new blank page
4. **Download**: Click "Download PDF" to save your modified PDF file

## 🏗️ Project Structure

```
pdf-modifier/
├── app/
│   ├── components/
│   │   ├── PdfEditor.vue    # Main editor component
│   │   └── PdfPage.vue      # Individual page component
│   ├── composables/
│   │   └── usePdf.ts        # PDF manipulation logic
│   └── app.vue              # Root application component
├── public/
│   └── test-file.pdf        # Sample PDF for testing
├── nuxt.config.ts           # Nuxt configuration
├── package.json             # Dependencies and scripts
└── tsconfig.json            # TypeScript configuration
```

## 🔒 Security & Privacy

All PDF processing happens entirely in your browser. No files are uploaded to any server, ensuring your documents remain private and secure.

## 📚 Documentation

- [Nuxt.js Documentation](https://nuxt.com/docs)
- [PDF.js Documentation](https://mozilla.github.io/pdf.js/)
- [pdf-lib Documentation](https://pdf-lib.js.org/)

## 📄 License

This project is private and not licensed for public use.

## 🤝 Contributing

This is a personal project. If you have suggestions or find issues, feel free to open an issue or submit a pull request.
