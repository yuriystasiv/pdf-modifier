import { ref } from 'vue';
import { PDFDocument } from 'pdf-lib';
import * as pdfjsLib from 'pdfjs-dist';

// Set worker source to use the local worker file
if (typeof window !== 'undefined') {
  pdfjsLib.GlobalWorkerOptions.workerSrc = new URL(
    'pdfjs-dist/build/pdf.worker.min.mjs',
    import.meta.url
  ).href;
}

export interface PdfPage {
  id: string;
  originalIndex: number;
  image: string; // Data URL of the rendered page
}

export const usePdf = () => {
  const pages = ref<PdfPage[]>([]);
  const pdfDoc = ref<PDFDocument | null>(null);
  const originalPdfBytes = ref<ArrayBuffer | null>(null);

  const loadPdf = async (file: File) => {
    const arrayBuffer = await file.arrayBuffer();
    
    // Store a copy of the original bytes for later use
    // We need to clone it because ArrayBuffers can be detached/transferred
    originalPdfBytes.value = arrayBuffer.slice(0);

    // Load into pdf-lib using a separate copy
    pdfDoc.value = await PDFDocument.load(arrayBuffer.slice(0));

    // Render pages using pdf.js with another copy
    const loadingTask = pdfjsLib.getDocument({ data: new Uint8Array(arrayBuffer) });
    const pdf = await loadingTask.promise;

    const newPages: PdfPage[] = [];

    for (let i = 1; i <= pdf.numPages; i++) {
      const page = await pdf.getPage(i);
      const viewport = page.getViewport({ scale: 0.5 }); // Thumbnail scale
      const canvas = document.createElement('canvas');
      const context = canvas.getContext('2d');
      canvas.height = viewport.height;
      canvas.width = viewport.width;

      if (context) {
        await page.render({ canvasContext: context, viewport: viewport }).promise;
        newPages.push({
          id: crypto.randomUUID(),
          originalIndex: i - 1,
          image: canvas.toDataURL(),
        });
      }
    }

    pages.value = newPages;
  };

  const removePage = (index: number) => {
    pages.value.splice(index, 1);
  };

  const movePage = (fromIndex: number, toIndex: number) => {
    const page = pages.value.splice(fromIndex, 1)[0];
    pages.value.splice(toIndex, 0, page);
  };

  const addBlankPage = () => {
    // For visual representation, we'll just add a placeholder.
    // In the actual PDF generation, we'll handle adding a blank page.
    const canvas = document.createElement('canvas');
    canvas.width = 300;
    canvas.height = 400;
    const ctx = canvas.getContext('2d');
    if (ctx) {
      ctx.fillStyle = 'white';
      ctx.fillRect(0, 0, 300, 400);
      ctx.strokeStyle = '#ccc';
      ctx.strokeRect(0, 0, 300, 400);
    }
    
    pages.value.push({
      id: crypto.randomUUID(),
      originalIndex: -1, // -1 indicates a new blank page
      image: canvas.toDataURL(),
    });
  };

  const downloadPdf = async () => {
    if (!originalPdfBytes.value) return;

    // Create a new PDF document
    const newPdf = await PDFDocument.create();
    
    // Load a fresh copy of the source document for copying pages
    // pdf-lib requires copying from a separate document instance
    const sourceDoc = await PDFDocument.load(originalPdfBytes.value);

    for (const page of pages.value) {
      if (page.originalIndex === -1) {
        // Add blank page
        newPdf.addPage();
      } else {
        // Copy page from source
        const [copiedPage] = await newPdf.copyPages(sourceDoc, [page.originalIndex]);
        newPdf.addPage(copiedPage);
      }
    }

    const pdfBytes = await newPdf.save();
    const blob = new Blob([pdfBytes], { type: 'application/pdf' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = 'edited.pdf';
    link.click();
  };

  return {
    pages,
    loadPdf,
    removePage,
    movePage,
    addBlankPage,
    downloadPdf,
  };
};
