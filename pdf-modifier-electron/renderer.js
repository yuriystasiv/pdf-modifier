// Import PDF.js and pdf-lib using require
const pdfjsLib = require('pdfjs-dist');
const { PDFDocument } = require('pdf-lib');
const { ipcRenderer } = require('electron');
const path = require('path');

// Configure PDF.js worker
pdfjsLib.GlobalWorkerOptions.workerSrc = path.join(__dirname, 'node_modules/pdfjs-dist/build/pdf.worker.js');

// Application state
let currentPdfDoc = null;
let pages = [];
let originalFileName = '';

// DOM elements
const uploadArea = document.getElementById('uploadArea');
const editorArea = document.getElementById('editorArea');
const selectFileBtn = document.getElementById('selectFileBtn');
const changeFileBtn = document.getElementById('changeFileBtn');
const downloadBtn = document.getElementById('downloadBtn');
const addPageBtn = document.getElementById('addPageBtn');
const fileName = document.getElementById('fileName');
const pageCount = document.getElementById('pageCount');
const pagesContainer = document.getElementById('pagesContainer');

// Event listeners
selectFileBtn.addEventListener('click', selectFile);
changeFileBtn.addEventListener('click', selectFile);
downloadBtn.addEventListener('click', downloadPDF);
addPageBtn.addEventListener('click', addBlankPage);

// File selection
async function selectFile() {
  try {
    const result = await ipcRenderer.invoke('select-pdf-file');
    
    if (!result) return;
    
    originalFileName = result.name;
    const pdfData = new Uint8Array(result.data);
    
    await loadPDF(pdfData);
  } catch (error) {
    console.error('Error selecting file:', error);
    alert('Error loading PDF file. Please try again.');
  }
}

// Load PDF
async function loadPDF(pdfData) {
  try {
    // Load with pdf-lib
    currentPdfDoc = await PDFDocument.load(pdfData);
    
    // Load with PDF.js for rendering
    const loadingTask = pdfjsLib.getDocument({ data: pdfData });
    const pdfDoc = await loadingTask.promise;
    
    // Extract all pages
    pages = [];
    for (let i = 1; i <= pdfDoc.numPages; i++) {
      const page = await pdfDoc.getPage(i);
      pages.push({
        pageNumber: i,
        pdfPage: page,
        type: 'original'
      });
    }
    
    // Update UI
    fileName.textContent = originalFileName;
    uploadArea.style.display = 'none';
    editorArea.style.display = 'flex';
    downloadBtn.disabled = false;
    
    renderPages();
  } catch (error) {
    console.error('Error loading PDF:', error);
    alert('Error loading PDF. Please ensure the file is valid.');
  }
}

// Render all pages
async function renderPages() {
  pagesContainer.innerHTML = '';
  pageCount.textContent = pages.length;
  
  for (let i = 0; i < pages.length; i++) {
    const pageCard = await createPageCard(pages[i], i);
    pagesContainer.appendChild(pageCard);
  }
}

// Create page card
async function createPageCard(pageData, index) {
  const card = document.createElement('div');
  card.className = 'page-card';
  card.draggable = true;
  card.dataset.index = index;
  
  // Drag events
  card.addEventListener('dragstart', handleDragStart);
  card.addEventListener('dragover', handleDragOver);
  card.addEventListener('drop', handleDrop);
  card.addEventListener('dragend', handleDragEnd);
  
  // Page info
  const pageInfo = document.createElement('div');
  pageInfo.className = 'page-info';
  
  const pageNumber = document.createElement('span');
  pageNumber.className = 'page-number';
  pageNumber.textContent = `Page ${index + 1}`;
  
  const pageActions = document.createElement('div');
  pageActions.className = 'page-actions';
  
  const deleteBtn = document.createElement('button');
  deleteBtn.className = 'delete';
  deleteBtn.title = 'Delete page';
  deleteBtn.innerHTML = `
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <polyline points="3 6 5 6 21 6"></polyline>
      <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
    </svg>
  `;
  deleteBtn.addEventListener('click', () => deletePage(index));
  
  pageActions.appendChild(deleteBtn);
  pageInfo.appendChild(pageNumber);
  pageInfo.appendChild(pageActions);
  
  // Page preview
  const preview = document.createElement('div');
  preview.className = 'page-preview';
  
  const canvas = document.createElement('canvas');
  preview.appendChild(canvas);
  
  // Render preview
  if (pageData.type === 'original') {
    const viewport = pageData.pdfPage.getViewport({ scale: 0.5 });
    canvas.width = viewport.width;
    canvas.height = viewport.height;
    
    const context = canvas.getContext('2d');
    await pageData.pdfPage.render({
      canvasContext: context,
      viewport: viewport
    }).promise;
  } else if (pageData.type === 'blank') {
    // Render blank page
    canvas.width = 200;
    canvas.height = 260;
    const context = canvas.getContext('2d');
    context.fillStyle = '#ffffff';
    context.fillRect(0, 0, canvas.width, canvas.height);
    context.strokeStyle = '#e0e0e0';
    context.strokeRect(0, 0, canvas.width, canvas.height);
  }
  
  card.appendChild(pageInfo);
  card.appendChild(preview);
  
  return card;
}

// Delete page
function deletePage(index) {
  if (pages.length === 1) {
    alert('Cannot delete the last page.');
    return;
  }
  
  pages.splice(index, 1);
  renderPages();
}

// Add blank page
function addBlankPage() {
  pages.push({
    type: 'blank'
  });
  renderPages();
}

// Drag and drop handlers
let draggedIndex = null;

function handleDragStart(e) {
  draggedIndex = parseInt(e.currentTarget.dataset.index);
  e.currentTarget.classList.add('dragging');
  e.dataTransfer.effectAllowed = 'move';
}

function handleDragOver(e) {
  e.preventDefault();
  e.dataTransfer.dropEffect = 'move';
  
  const card = e.currentTarget;
  if (!card.classList.contains('dragging')) {
    card.classList.add('drag-over');
  }
}

function handleDrop(e) {
  e.preventDefault();
  
  const dropIndex = parseInt(e.currentTarget.dataset.index);
  
  if (draggedIndex !== null && draggedIndex !== dropIndex) {
    // Reorder pages
    const [draggedPage] = pages.splice(draggedIndex, 1);
    pages.splice(dropIndex, 0, draggedPage);
    renderPages();
  }
  
  e.currentTarget.classList.remove('drag-over');
}

function handleDragEnd(e) {
  e.currentTarget.classList.remove('dragging');
  document.querySelectorAll('.page-card').forEach(card => {
    card.classList.remove('drag-over');
  });
  draggedIndex = null;
}

// Download PDF
async function downloadPDF() {
  try {
    downloadBtn.disabled = true;
    downloadBtn.textContent = 'Processing...';
    
    // Create new PDF document
    const newPdfDoc = await PDFDocument.create();
    
    for (const pageData of pages) {
      if (pageData.type === 'original') {
        // Copy page from original PDF
        const [copiedPage] = await newPdfDoc.copyPages(currentPdfDoc, [pageData.pageNumber - 1]);
        newPdfDoc.addPage(copiedPage);
      } else if (pageData.type === 'blank') {
        // Add blank page
        newPdfDoc.addPage([612, 792]); // US Letter size
      }
    }
    
    // Serialize PDF
    const pdfBytes = await newPdfDoc.save();
    
    // Save file
    const defaultName = originalFileName.replace('.pdf', '_edited.pdf');
    const result = await ipcRenderer.invoke('save-pdf-file', { data: Array.from(pdfBytes), defaultName });
    
    if (result.success) {
      alert('PDF saved successfully!');
    } else {
      alert('Error saving PDF. Please try again.');
    }
  } catch (error) {
    console.error('Error downloading PDF:', error);
    alert('Error creating PDF. Please try again.');
  } finally {
    downloadBtn.disabled = false;
    downloadBtn.innerHTML = `
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
        <polyline points="7 10 12 15 17 10"></polyline>
        <line x1="12" y1="15" x2="12" y2="3"></line>
      </svg>
      Download PDF
    `;
  }
}
