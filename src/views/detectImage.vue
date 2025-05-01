<template>
  <!-- Main container with themed background -->
  <div class="outside-scene-page">
    <MyNavBar />

    <!-- Hero Banner Section -->
    <div class="hero-banner">
      <div class="hero-image-container">
        <img
          src="/detect-image.png"
          alt="Illustration for item suitability check"
          class="hero-image"
        />
      </div>
      <div class="hero-text-overlay">
        <div class="container text-center">
          <h1 class="main-title">Prepare for {{ getSceneTitleText }}</h1>
          <p class="main-subtitle">
            Check if items are suitable for your child's needs during different outings and activities.
            Upload a photo to see if it matches our recommended items list.
          </p>
        </div>
      </div>
          </div>
          
    <!-- Main Detection Section Container -->
    <div class="interactive-section-container container my-4">
      <div class="interactive-content mx-auto">
        <!-- Back Button -->
        <div class="text-left mb-3">
          <button class="btn btn-secondary" @click="goBack">
            <i class="fas fa-arrow-left me-2"></i> Back
          </button>
        </div>
        <!-- Step Title -->
        <h3 class="step-title mb-3">3. Is this item suitable to bring?</h3>
        <p class="step-subtitle mb-4">Let's check if what you plan to bring fits the needs of your child in this environment.</p>

        <!-- add image -->
        <div class="check-item-image-container mb-4">
          <img 
            src="/check-item.png" 
            alt="Check if item is suitable" 
            class="check-item-image" 
          />
        </div>

        <!-- File Upload Card -->
        <div class="upload-card mb-4">
          <div class="card-body">
            <div class="file-upload-container text-center">
              <div 
                class="file-drop-area"
                @dragover.prevent="onDragOver"
                @dragleave.prevent="onDragLeave"
                @dragenter.prevent="onDragEnter"
                @drop.prevent="onFileDrop"
                @click="triggerFileInput"
                :class="{ 'dragging': isDragging }"
              >
                <input 
                  type="file" 
                  ref="fileInput" 
                  class="file-input-hidden" 
                  @change="onFileSelected" 
                  accept="image/*"
                >
                <div v-if="!selectedFile" class="upload-prompt">
                  <i class="fas fa-cloud-upload-alt upload-icon"></i>
                  <p>Drag and drop an image here or click to browse</p>
                  <span class="small text-muted">Supported formats: JPG, PNG, GIF</span>
                </div>
                <div v-else class="image-preview-container">
                  <img :src="imagePreview" alt="Selected image preview" class="image-preview">
                </div>
              </div>
              
              <div class="mt-3 d-flex justify-content-center">
                <button 
                  class="btn btn-reset me-3" 
                  @click="resetDetection"
                  v-if="selectedFile"
                >
                  <i class="fas fa-undo me-2"></i> Reset
                </button>
                <button 
                  class="btn btn-action" 
                  @click="analyzeImage" 
                  :disabled="!selectedFile || isLoading"
                >
                  <i class="fas fa-search me-2"></i>
                  {{ isLoading ? 'Analysing...' : 'Analyse Item' }}
                </button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Loading Indicator -->
        <div v-if="isLoading" class="text-center my-4">
          <div class="spinner-border text-primary-custom" role="status">
            <span class="visually-hidden">Loading...</span>
      </div>
          <p class="loading-text mt-2">Analysing your item...</p>
        </div>

        <!-- Results Section -->
        <div v-if="results && !isLoading" class="results-section">
          <!-- Detection Result Summary -->
          <div class="detection-results-card">
            <div class="card-body">
              <h4 class="results-title">
                <i class="fas fa-clipboard-check me-2"></i>
                Detection Results
              </h4>

          <!-- Item description from image analysis -->
          <div class="item-description mb-4" v-if="results.description && results.description.captions.length">
            <h5 class="section-subtitle">We detected:</h5>
            <p class="description-text">
              {{ results.description.captions[0].text }}
            </p>
      </div>
      
          <!-- Detection Status -->
          <div v-if="isSuitableItem" class="detection-status success">
            <div class="status-icon">
              <i class="fas fa-check-circle"></i>
          </div>
          <div class="status-message">
            <h5>This item is suitable!</h5>
            <p>This matches our recommended items list for this activity.</p>
          </div>
        </div>
        
          <div v-else class="detection-status warning">
            <div class="status-icon">
              <i class="fas fa-exclamation-circle"></i>
        </div>
            <div class="status-message">
              <h5>This item might not be essential for this outing.</h5>
              <p>It’s not included in our top recommended list for this scenario, but feel free to bring it if it helps your child.</p>
        </div>
        </div>
        
        <!--
        <div class="detected-labels mt-4">
          <h5 class="section-subtitle">Detected Labels:</h5>
          <div class="labels-container">
            <span 
              v-for="(tag, index) in results.tags" 
              :key="'tag-'+index" 
              class="label-tag"
              :class="{ 'label-matched': matchedTerms.includes(tag.name.toLowerCase()) }"
            >
              {{ tag.name }}
              <i v-if="matchedTerms.includes(tag.name.toLowerCase())" class="fas fa-check ms-1"></i>
            </span>
          </div>
        </div>
        -->

        
        <!-- Recommended Items -->
        <div class="recommended-items mt-4">
          <h5 class="section-subtitle">Consider bringing these recommended items:</h5>
          <ul class="checklist">
            <li v-for="item in checklistItems" :key="item.id" class="checklist-item">
              <div class="checklist-item-icon">
                <i class="fas fa-check-circle"></i>
              </div>

              <div class="checklist-item-content">
                <div class="item-row">
                  <div class="item-text">
                    <strong>{{ item.title }}</strong>
                    <p class="item-description">{{ item.description }}</p>
                  </div>
                  <div class="item-image-container" v-if="item.image_url">
                    <img 
                      :src="getImageUrl(item)" 
                      :alt="item.title"
                      class="item-image"
                      @error="handleImageError($event, item)"
                      @load="onImageLoaded(item)"
                    >
                  </div>
                </div>
              </div>
            </li>

          </ul>
        </div>
        
        <!-- Navigation Buttons -->
        <div class="text-center mt-4">
          <button class="btn btn-secondary me-3" @click="goBack">
            <i class="fas fa-arrow-left me-2"></i> Back
          </button>
          <button class="btn btn-action" @click="goToNext">
            View My Summary <i class="fas fa-arrow-right ms-2"></i>
              </button>
        </div>
      </div>
        </div>
      </div>
      
        <!-- Error Message -->
        <div v-if="error" class="alert alert-danger error-box mx-auto" style="max-width: 700px;">
          <strong>Error:</strong> {{ error }}
          <p class="mb-0 mt-1"><small>Unable to analyse the image. Please try again with a clearer photo.</small></p>
        </div>
      </div>
    </div>

    <MyFooter />
    </div>
  </template>
  
  <script>
import { ref, computed, onMounted } from 'vue';
  import axios from 'axios';
import AOS from 'aos';
import 'aos/dist/aos.css';
import MyNavBar from '../components/test/MyNavBar.vue';
import MyFooter from '../components/test/MyFooter.vue';
import { useRouter, useRoute } from 'vue-router';
  
  export default {
  name: 'DetectImage',
  components: {
    MyNavBar,
    MyFooter
  },
  setup() {
    // Add router and route
    const router = useRouter();
    const route = useRoute();

    // State
    const selectedFile = ref(null);
    const imagePreview = ref(null);
    const results = ref(null);
    const isLoading = ref(false);
    const error = ref(null);
    const fileInput = ref(null);
    const checklistItems = ref([]);
    const validTerms = ref([]);
    const isDragging = ref(false);
    const debugImageInfo = ref(false);
    
    // Get sceneId from route query or use default
    const sceneId = ref(parseInt(route.query.sceneId || '1'));

    const API_BASE_URL = 'http://localhost:3000/api';
    const IMAGE_BASE_URL = 'http://localhost:3000/image';

    // Computed properties
    const matchedTerms = computed(() => {
      if (!results.value || !results.value.tags || validTerms.value.length === 0) {
        return [];
      }

      return results.value.tags
        .map(tag => tag.name.toLowerCase())
        .filter(tagName => validTerms.value.includes(tagName));
    });

    const isSuitableItem = computed(() => {
      return matchedTerms.value.length > 0;
    });

    // get scene title based on sceneId
    const getSceneTitleText = computed(() => {
      switch(sceneId.value) {
        case 1:
          return "a Medical Visit";
        case 2:
          return "Airport Travel";
        case 3:
          return "a Leisure Outing";
        case 4:
          return "a School Visit";
        default:
          return "a Successful Outing";
      }
    });

    // Methods
    const onFileSelected = (event) => {
      const file = event.target.files[0];
      if (file) {
        processSelectedFile(file);
      }
    };

    const onDragEnter = () => {
      isDragging.value = true;
    };
    
    const onDragLeave = () => {
      isDragging.value = false;
    };

    const onDragOver = (event) => {
      event.preventDefault();
      isDragging.value = true;
    };

    const onFileDrop = (event) => {
      isDragging.value = false;
      const file = event.dataTransfer.files[0];
      if (file && file.type.match('image.*')) {
        processSelectedFile(file);
      }
    };

    const triggerFileInput = () => {
      fileInput.value.click();
    };

    const processSelectedFile = (file) => {
      selectedFile.value = file;
      results.value = null;
      error.value = null;

      // Create image preview
          const reader = new FileReader();
          reader.onload = (e) => {
        imagePreview.value = e.target.result;
      };
      reader.readAsDataURL(file);
    };

    const readFileAsArrayBuffer = (file) => {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = (e) => resolve(e.target.result);
        reader.onerror = (e) => reject(e);
        reader.readAsArrayBuffer(file);
      });
    };

    const analyzeImage = async () => {
      if (!selectedFile.value) {
        error.value = 'Please select an image file first';
          return;
        }
        
      isLoading.value = true;
      error.value = null;
        
        try {
        // Read file as binary data
        const fileData = await readFileAsArrayBuffer(selectedFile.value);
          
        // Call Azure Computer Vision API
          const response = await axios({
            method: 'post',
          url: 'https://5120.cognitiveservices.azure.com/vision/v3.2/analyze?visualFeatures=Objects,Tags,Description',
            headers: {
              'Content-Type': 'application/octet-stream',
            'Ocp-Apim-Subscription-Key': 'EdLSbueKzPgxgxulSFPvVJkH4dOFmJp3IwC9Y1SQBZq56LqCoWEaJQQJ99BDACL93NaXJ3w3AAAFACOGI0sm'
            },
            data: fileData,
            transformRequest: [(data) => data]
          });
          
        results.value = response.data;
        console.log("API response:", results.value);

        // Fetch checklist items if not already loaded
        if (checklistItems.value.length === 0) {
          await fetchChecklistItems();
        }
      } catch (error) {
        console.error('Image analysis error:', error);
        error.value = error.response ? 
          `API Error (${error.response.status}): ${error.response.data.message || error.message}` :
          `Error: ${error.message}`;
      } finally {
        isLoading.value = false;
      }
    };

    const resetDetection = () => {
      selectedFile.value = null;
      imagePreview.value = null;
      results.value = null;
      error.value = null;
      // Reset file input value
      if (fileInput.value) {
        fileInput.value.value = '';
      }
    };

    const fetchChecklistItems = async () => {
      try {
        // Fetch checklist items for the current scene
        const checklistResponse = await axios.get(`${API_BASE_URL}/scenes/${sceneId.value}/checklist`);
        console.log("API响应:", checklistResponse.data);
        
        if (checklistResponse.data.success) {
          checklistItems.value = checklistResponse.data.data;
          console.log("加载了物品列表:", checklistItems.value);
          
          // check if the received data contains image_url
          const hasImages = checklistItems.value.some(item => item.image_url);
          console.log("是否有图片URL:", hasImages);
          if (!hasImages) {
            console.warn("API返回的数据中没有图片URL");
          }
        }

        // Fetch valid terms for matching
        const termsResponse = await axios.get(`${API_BASE_URL}/scenes/${sceneId.value}/terms`);
        if (termsResponse.data.success) {
          validTerms.value = termsResponse.data.data;
          console.log("Valid terms loaded:", validTerms.value.length);
        }
      } catch (err) {
        console.error("Error fetching checklist data:", err);
        error.value = "Failed to load checklist data. Please try again.";
      }
    };

    // Navigation methods
    const goBack = () => {
      router.push('/detectpage');
    };

    const goToNext = () => {
      router.push({
        path: '/detectSummary',
        query: { sceneId: sceneId.value }
      });
    };

    const onImageLoaded = (item) => {
      console.log(`图片加载成功: ${item.title}`);
    };

    const handleImageError = (event, item) => {
      console.log(`图片加载失败: ${item.title}`, event);
      // use a generic placeholder image
      event.target.src = `${IMAGE_BASE_URL}/Sunglasses.png`;
    };

    const getImageUrl = (item) => {
      if (!item.image_url) return null;
      
      // check special cases
      if (item.title === "Fun-pattern bandage or sticker" && 
          item.image_url === "Fun-pattern bandage.png") {
        return `${IMAGE_BASE_URL}/Fun-pattern bandage.png`;
      }

      // normal cases
      return `${IMAGE_BASE_URL}/${item.image_url}`;
    };

    // Lifecycle hooks
    onMounted(() => {
      AOS.init({ duration: 600, once: true, offset: 50 });
      fetchChecklistItems();
    });

    return {
      // State
      selectedFile,
      imagePreview,
      results,
      isLoading,
      error,
      fileInput,
      checklistItems,
      
      // Computed
      matchedTerms,
      isSuitableItem,
      getSceneTitleText,
      
      // Methods
      onFileSelected,
      onDragEnter,
      onDragLeave,
      onDragOver,
      onFileDrop,
      triggerFileInput,
      analyzeImage,
      resetDetection,
      goBack,
      goToNext,
      sceneId,
      isDragging,
      handleImageError,
      API_BASE_URL,
      IMAGE_BASE_URL,
      debugImageInfo,
      onImageLoaded,
      getImageUrl
    };
  }
};
</script>

<style scoped>
/* Core theme colors */
:root {
  --background-main: #F8EFED;
  --text-brown: #4d2f20;
  --primary-green: #3E5C2B;
  --card-bg: #FFFFFF;
  --border-color: #e0e0e0;
  --success-color: #2e8540;
  --warning-color: #e59700;
}

/* Global page background */
.outside-scene-page {
  background-color: var(--background-main);
  min-height: 100vh;
  width: 100%;
  display: flex;
  flex-direction: column;
}

/* Hero Banner styling */
.hero-banner {
  position: relative;
  width: 100%;
  height: 400px;
  overflow: hidden;
  margin-bottom: 0;
}

.hero-image-container {
  width: 100%;
  height: 100%;
}

.hero-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center 30%;
}

.hero-text-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.5);
}

.main-title {
  color: #4d2f20;
  font-size: 2.7rem;
  font-weight: 700;
  margin-bottom: 1rem;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

.main-subtitle {
  color: #4d2f20;
  font-size: 1.3rem;
  margin-bottom: 0;
  line-height: 1.6;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

/* Interactive Section Styling */
.interactive-section-container {
  flex-grow: 1;
  padding-bottom: 3rem;
}

.interactive-content {
  max-width: 800px;
  width: 100%;
}

.step-title {
  color: #4d2f20;
  font-weight: 700;
  margin-bottom: 0.75rem;
  font-size: 1.6rem;
  text-align: center;
}

.step-subtitle {
  color: #666;
  font-size: 1.1rem;
  text-align: center;
  max-width: 600px;
  margin: 0 auto 1.5rem;
  line-height: 1.5;
}

/* File Upload Section */
.upload-card {
  background-color: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  margin-bottom: 2rem;
}

.file-drop-area {
  border: 2px dashed #ccc;
    border-radius: 8px;
  padding: 3.5rem;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: #f8f9fa;
  position: relative;
  min-height: 250px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.file-drop-area.dragging {
  border-color: #3E5C2B;
  background-color: #f0f7ed;
  transform: scale(1.02);
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.file-drop-area.dragging .upload-icon {
  transform: translateY(-5px);
  color: #4d7234;
}

.file-drop-area.dragging:after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 6px;
  border: 2px solid #3E5C2B;
  opacity: 0.3;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% {
    transform: scale(1);
    opacity: 0.6;
  }
  50% {
    transform: scale(1.03);
    opacity: 0.3;
  }
  100% {
    transform: scale(1);
    opacity: 0.6;
  }
}

.file-input-hidden {
  display: none;
}

.upload-icon {
  font-size: 3rem;
  color: #3E5C2B;
  margin-bottom: 1rem;
}

.upload-prompt {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100%;
  width: 100%;
}

.upload-prompt p {
  font-size: 1.15rem;
  color: #666;
  margin-bottom: 0.5rem;
}

.image-preview-container {
  max-height: 400px;
  overflow: hidden;
  border-radius: 6px;
  display: flex;
  justify-content: center;
  align-items: center;
    width: 100%;
  }
  
.image-preview {
  max-width: 100%;
  max-height: 400px;
  object-fit: contain;
}

/* Buttons */
.btn-action {
  background-color: #3E5C2B;
  color: white;
  border: none;
  padding: 0.6rem 1.5rem;
  border-radius: 50px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-action:hover {
  background-color: #4d7234;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.btn-action:disabled {
  background-color: #a0a0a0;
  cursor: not-allowed;
  transform: none;
  box-shadow: none;
}

.btn-reset {
  background-color: #f8f9fa;
  color: #6c757d;
  border: 1px solid #dee2e6;
  padding: 0.6rem 1.5rem;
  border-radius: 50px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-reset:hover {
  background-color: #e2e6ea;
  color: #495057;
}

/* Loading indicator */
.text-primary-custom {
  color: #3E5C2B !important;
}

.loading-text {
  color: #4d2f20;
  font-size: 1.1rem;
}

/* Results Section */
.results-section {
  margin-top: 2rem;
}

.detection-results-card {
  background-color: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  padding: 1.5rem;
}

.results-title {
  color: #4d2f20;
  font-weight: 600;
  margin-bottom: 1.5rem;
  font-size: 1.4rem;
  border-bottom: 1px solid #eee;
  padding-bottom: 0.75rem;
}

.section-subtitle {
  color: #4d2f20;
  font-weight: 600;
  font-size: 1.1rem;
  margin-bottom: 0.75rem;
}

.item-description {
  background-color: #f8f9fa;
  padding: 1rem;
  border-radius: 8px;
  border-left: 4px solid #3E5C2B;
}

.description-text {
  margin-bottom: 0;
  color: #4d2f20;
  font-size: 1.1rem;
}

/* Detection Status */
.detection-status {
  display: flex;
  align-items: flex-start;
  padding: 2rem;
  border-radius: 12px;
  margin: 1.5rem 0;
}

.detection-status.success {
  background-color: #f0f7ed;
  border-left: 6px solid #3E5C2B;
}

.detection-status.warning {
  background-color: #fff8e6;
  border-left: 6px solid #e59700;
}

.status-icon {
  font-size: 3.5rem;
  margin-right: 1.5rem;
  flex-shrink: 0;
}

.detection-status.success .status-icon {
  color: #3E5C2B;
}

.detection-status.warning .status-icon {
  color: #e59700;
}

.status-message h5 {
  color: #4d2f20;
  font-weight: 700;
  margin-bottom: 0.75rem;
  font-size: 1.5rem;
}

.status-message p {
    color: #666;
  margin-bottom: 0;
  font-size: 1.15rem;
  line-height: 1.5;
  }
  
/* Detected Labels */
.labels-container {
    display: flex;
    flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.75rem;
}

.label-tag {
  background-color: #f0f0f0;
  color: #4d2f20;
  padding: 0.4rem 0.8rem;
  border-radius: 20px;
  font-size: 0.9rem;
  display: inline-flex;
    align-items: center;
}

.label-matched {
  background-color: #e8f4e5;
  color: #3E5C2B;
  font-weight: 600;
}

/* Checklist Items */
.checklist {
  list-style: none;
  padding: 0;
  margin: 0;
}

.checklist-item {
  display: flex;
  align-items: flex-start;
  padding: 1rem 0;
  border-bottom: 1px solid #eee;
}

.checklist-item:last-child {
  border-bottom: none;
}

.checklist-item-icon {
  color: #3E5C2B;
  margin-top: 0.25rem;
  margin-right: 0.75rem;
  flex-shrink: 0;
}

.checklist-item-content {
  flex-grow: 1;
}

.checklist-item strong {
  color: #4d2f20;
  display: block;
  margin-bottom: 0.25rem;
  font-size: 1.05rem;
}

.item-description {
  color: #4d2f20;
  margin-bottom: 0.75rem;
  font-size: 0.95rem;
}

.item-image-container {
  width: 100%;
  max-width: 150px;
  margin: 0.5rem 0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.item-image {
  width: 100%;
  height: auto;
  object-fit: cover;
    display: block;
  transition: transform 0.3s ease;
}

.item-image:hover {
  transform: scale(1.05);
}

/* Error box */
.error-box {
  border-left: 4px solid #dc3545;
}

/* Navigation Buttons */
.btn-secondary {
  background-color: #f8f9fa;
  color: #4d2f20;
  border: 1px solid #e0e0e0;
  padding: 0.6rem 1.5rem;
  border-radius: 50px;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-secondary:hover {
  background-color: #e9ecef;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* 添加 hover 效果 */
.file-drop-area:hover {
  border-color: #3E5C2B;
  background-color: #f0f7ed;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
}

/* 新增的图片容器样式 */
.check-item-image-container {
  text-align: center;
  max-width: 500px;
  margin: 0 auto 2rem;
}

.check-item-image {
  width: 100%;
  height: auto;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

@media (max-width: 768px) {
  .hero-banner {
    height: 300px;
  }
  
  .main-title {
    font-size: 2rem;
  }
  
  .main-subtitle {
    font-size: 1.1rem;
  }
  
  .detection-status {
    flex-direction: column;
  }
  
  .status-icon {
    margin-right: 0;
    margin-bottom: 1rem;
  }
}

/* 对齐样式 */
.text-left {
  text-align: left;
  }
/* 横向排列文字和图片 */
.item-row {
    display: flex;
  align-items: flex-start;
  gap: 1.5rem;
    flex-wrap: wrap;
}

.item-text {
  flex: 1 1 60%;
}

.item-image-container {
  flex: 0 0 150px;
  max-width: 150px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.item-image {
  width: 100%;
  height: auto;
  object-fit: cover;
  display: block;
}

  </style>


