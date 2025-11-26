<template>
  <div class="pdf-page" draggable="true" @dragstart="onDragStart" @dragover.prevent @drop="onDrop">
    <div class="page-controls">
      <button @click="$emit('move-left')" :disabled="isFirst" title="Move Left">&lt;</button>
      <button @click="$emit('delete')" class="delete-btn" title="Delete">X</button>
      <button @click="$emit('move-right')" :disabled="isLast" title="Move Right">&gt;</button>
    </div>
    <img :src="page.image" alt="PDF Page" />
    <div class="page-number">Page {{ index + 1 }}</div>
  </div>
</template>

<script setup lang="ts">
import type { PdfPage } from '~/composables/usePdf';

const props = defineProps<{
  page: PdfPage;
  index: number;
  isFirst: boolean;
  isLast: boolean;
}>();

const emit = defineEmits<{
  (e: 'delete'): void;
  (e: 'move-left'): void;
  (e: 'move-right'): void;
  (e: 'drag-start', index: number): void;
  (e: 'drop', index: number): void;
}>();

const onDragStart = (event: DragEvent) => {
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'move';
    event.dataTransfer.setData('text/plain', props.index.toString());
  }
  emit('drag-start', props.index);
};

const onDrop = (event: DragEvent) => {
  emit('drop', props.index);
};
</script>

<style scoped>
.pdf-page {
  position: relative;
  border: 1px solid #ddd;
  padding: 10px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: transform 0.2s;
  cursor: grab;
}

.pdf-page:active {
  cursor: grabbing;
}

.pdf-page img {
  max-width: 100%;
  height: auto;
  border: 1px solid #eee;
}

.page-controls {
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin-bottom: 8px;
}

button {
  background: #f0f0f0;
  border: none;
  border-radius: 4px;
  padding: 4px 8px;
  cursor: pointer;
}

button:hover {
  background: #e0e0e0;
}

button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.delete-btn {
  background: #ffdddd;
  color: #d00;
}

.delete-btn:hover {
  background: #ffcccc;
}

.page-number {
  margin-top: 5px;
  font-size: 0.8rem;
  color: #666;
}
</style>
