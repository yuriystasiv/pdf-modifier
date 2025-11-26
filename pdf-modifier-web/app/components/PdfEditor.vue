<template>
  <div class="pdf-editor">
    <div v-if="pages.length === 0" class="upload-section">
      <label class="upload-btn">
        Upload PDF
        <input type="file" accept="application/pdf" @change="handleFileUpload" hidden />
      </label>
    </div>

    <div v-else class="editor-section">
      <div class="toolbar">
        <button @click="addBlankPage" class="action-btn">Add Blank Page</button>
        <button @click="downloadPdf" class="primary-btn">Download PDF</button>
      </div>

      <div class="pages-grid">
        <PdfPage
          v-for="(page, index) in pages"
          :key="page.id"
          :page="page"
          :index="index"
          :is-first="index === 0"
          :is-last="index === pages.length - 1"
          @delete="removePage(index)"
          @move-left="movePage(index, index - 1)"
          @move-right="movePage(index, index + 1)"
          @drag-start="onDragStart"
          @drop="onDrop(index)"
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { usePdf } from '~/composables/usePdf';

const { pages, loadPdf, removePage, movePage, addBlankPage, downloadPdf } = usePdf();
const draggedIndex = ref<number | null>(null);

const handleFileUpload = async (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files[0]) {
    await loadPdf(target.files[0]);
  }
};

const onDragStart = (index: number) => {
  draggedIndex.value = index;
};

const onDrop = (dropIndex: number) => {
  if (draggedIndex.value !== null && draggedIndex.value !== dropIndex) {
    movePage(draggedIndex.value, dropIndex);
  }
  draggedIndex.value = null;
};
</script>

<style scoped>
.pdf-editor {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.upload-section {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 400px;
  border: 2px dashed #ccc;
  border-radius: 12px;
  background: #f9f9f9;
}

.upload-btn {
  padding: 12px 24px;
  background: #007bff;
  color: white;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1.2rem;
  transition: background 0.2s;
}

.upload-btn:hover {
  background: #0056b3;
}

.toolbar {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  justify-content: flex-end;
}

.action-btn, .primary-btn {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
}

.action-btn {
  background: #e0e0e0;
  color: #333;
}

.primary-btn {
  background: #28a745;
  color: white;
}

.pages-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 20px;
}
</style>
