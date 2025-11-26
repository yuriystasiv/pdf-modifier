const { contextBridge, ipcRenderer } = require('electron');

// Expose protected methods that allow the renderer process to use
// the ipcRenderer without exposing the entire object
contextBridge.exposeInMainWorld('electronAPI', {
  selectPdfFile: () => ipcRenderer.invoke('select-pdf-file'),
  savePdfFile: (data, defaultName) => ipcRenderer.invoke('save-pdf-file', { data, defaultName })
});
