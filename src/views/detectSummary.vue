<template>
  <!-- Main container with themed background -->
  <div class="outside-scene-page">
    <MyNavBar />

    <!-- Hero Banner Section -->
    <div class="hero-banner">
      <div class="hero-image-container">
        <img
          src="/detect-image.png"
          alt="Illustration for successful preparation"
          class="hero-image"
        />
      </div>
      <div class="hero-text-overlay">
        <div class="container text-center">
          <h1 class="main-title">You Are Ready!</h1>
          <p class="main-subtitle">
            You've successfully prepared for your outing. Here's a summary of what to expect and what to bring.
          </p>
        </div>
      </div>
    </div>

    <!-- Main Summary Section Container -->
    <div class="interactive-section-container container my-4">
      <div class="interactive-content mx-auto">
        
        <!-- Two Column Layout for Summary -->
        <div class="row summary-container">
          <!-- Left Column: Environmental Expectations -->
          <div class="col-md-6 mb-4">
            <div class="summary-card">
              <h3 class="summary-title">
                <i class="fas fa-map-marked-alt me-2"></i>
                What to Expect
              </h3>
              <div class="expectations-list">
                <div v-if="isLoading" class="text-center my-3">
                  <div class="spinner-border text-primary-custom" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                  <p class="loading-text mt-2">Loading sensory details...</p>
                </div>
                
                <div v-else-if="error" class="alert alert-danger error-box">
                  <strong>Error:</strong> {{ error }}
                </div>
                
                <div v-else-if="sensoryExpectations.length === 0" class="alert alert-info">
                  No expectations found for this scene.
                </div>
                
                <div v-else>
                  <div v-for="(item, index) in sensoryExpectations" :key="item.id"
                       class="expectation-item">
                    <div class="d-flex align-items-start">
                      <span class="expectation-icon me-3">{{ getIconForCategory(item.category) }}</span>
                      <div>
                        <h5 class="expectation-category text-capitalize">{{ item.category }}</h5>
                        <p class="expectation-description">{{ item.description }}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Right Column: Checklist Items -->
          <div class="col-md-6 mb-4">
            <div class="summary-card">
              <h3 class="summary-title">
                <i class="fas fa-clipboard-check me-2"></i>
                What to Bring
              </h3>
              <div class="checklist-summary">
                <div v-if="isLoading" class="text-center my-3">
                  <div class="spinner-border text-primary-custom" role="status">
                    <span class="visually-hidden">Loading...</span>
                  </div>
                  <p class="loading-text mt-2">Loading checklist items...</p>
                </div>
                
                <div v-else-if="error" class="alert alert-danger error-box">
                  <strong>Error:</strong> {{ error }}
                </div>
                
                <div v-else-if="checklistItems.length === 0" class="alert alert-info">
                  No checklist items found for this scene.
                </div>
                
                <div v-else>
                  <ul class="checklist">
                    <li v-for="item in checklistItems" :key="item.id" class="checklist-item">
                      <i class="fas fa-check-circle me-2"></i>
                      <div>
                        <strong>{{ item.title }}</strong>
                        <p class="item-description">{{ item.description }}</p>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons mt-4 d-flex justify-content-center">
          <button class="btn btn-secondary me-3" @click="goBack">
            <i class="fas fa-arrow-left me-2"></i> Back
          </button>
          <button class="btn btn-action" @click="goToSelectScene">
            <i class="fas fa-redo me-2"></i> Select New Scene
          </button>
        </div>
      </div>
    </div>

    <MyFooter />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import AOS from 'aos';
import 'aos/dist/aos.css';
import MyNavBar from '../components/test/MyNavBar.vue';
import MyFooter from '../components/test/MyFooter.vue';
import { useRouter, useRoute } from 'vue-router';

export default {
  name: 'DetectSummary',
  components: {
    MyNavBar,
    MyFooter
  },
  setup() {
    // State
    const router = useRouter();
    const route = useRoute();
    const sensoryExpectations = ref([]);
    const checklistItems = ref([]);
    const isLoading = ref(true);
    const error = ref(null);
    const sceneId = ref(parseInt(route.query.sceneId || '1'));

    const API_BASE_URL = '/api';

    // Methods
    const getIconForCategory = (category) => { 
      switch (category?.toLowerCase()) { 
        case 'hearing': return '👂'; 
        case 'sight': return '💡'; 
        case 'smell': return '👃'; 
        case 'touch': return '🖐️'; 
        default: return '🧠'; 
      } 
    };

    const fetchData = async () => {
      isLoading.value = true;
      error.value = null;
      
      try {
        // Fetch sensory expectations
        const sensoryResponse = await axios.get(`${API_BASE_URL}/scenes/${sceneId.value}/sensory-expectations`);
        if (sensoryResponse.data.success && Array.isArray(sensoryResponse.data.data)) {
          sensoryExpectations.value = sensoryResponse.data.data;
        } else {
          throw new Error('Invalid data format received for sensory expectations');
        }
        
        // Fetch checklist items
        const checklistResponse = await axios.get(`${API_BASE_URL}/scenes/${sceneId.value}/checklist`);
        if (checklistResponse.data.success) {
          checklistItems.value = checklistResponse.data.data;
        } else {
          throw new Error('Invalid data format received for checklist items');
        }
      } catch (err) {
        console.error("Error fetching data:", err);
        error.value = "Could not load data. Please try again later.";
      } finally {
        isLoading.value = false;
      }
    };

    // Navigation methods
    const goBack = () => {
      router.push({
        path: '/detectImage',
        query: { sceneId: sceneId.value }
      });
    };

    const goToSelectScene = () => {
      router.push('/detectpage');
    };

    // Lifecycle hooks
    onMounted(() => {
      AOS.init({ duration: 600, once: true, offset: 50 });
      fetchData();
    });

    return {
      sensoryExpectations,
      checklistItems,
      isLoading,
      error,
      getIconForCategory,
      goBack,
      goToSelectScene,
      sceneId
    };
  }
};
</script>

<style scoped>

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
  color:#4d2f20;
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
  max-width: 1000px;
  width: 100%;
}

/* Summary Cards */
.summary-container {
  margin-top: 2rem;
}

.summary-card {
  background-color: #F8EFED;
  border-radius: 12px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  padding: 1.5rem;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.summary-title {
  color: #4d2f20;
  font-weight: 600;
  margin-bottom: 1.5rem;
  font-size: 1.4rem;
  border-bottom: 1px solid #eee;
  padding-bottom: 0.75rem;
}

/* Expectations styling */
.expectations-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.expectation-item {
  background-color: rgba(255, 255, 255, 0.95);
  border: none;
  border-left: 4px solid #3E5C2B;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  padding: 1rem;
  transition: all 0.3s ease;
  margin-bottom: 1rem;
}

.expectation-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
}

.expectation-icon { 
  color: #3E5C2B;
  font-size: 1.8rem;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
}

.expectation-category {
  color: #3E5C2B;
  font-weight: 600;
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
}

.expectation-description {
  color: #4d2f20; 
  font-size: 1rem; 
  line-height: 1.5;
  margin-bottom: 0;
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
  padding: 0.75rem;
  margin-bottom: 1rem;
  background-color: #f8f9fa;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.checklist-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
}

.checklist-item i {
  color: #3E5C2B;
  margin-top: 0.25rem;
  font-size: 1.2rem;
}

.checklist-item strong {
  color: #4d2f20;
  display: block;
  margin-bottom: 0.25rem;
  font-size: 1.1rem;
}

.item-description {
  color: #4d2f20;
  margin-bottom: 0;
  font-size: 0.95rem;
}

/* Action Buttons */
.action-buttons {
  margin-top: 2rem;
}

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

.btn-secondary {
  background-color: #f8f9fa;
  color: var(--text-brown);
  border: 1px solid var(--border-color);
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

/* Loading indicator */
.text-primary-custom {
  color: #3E5C2B !important;
}

.loading-text {
  color: #4d2f20;
  font-size: 1rem;
}

/* Error box */
.error-box {
  border-left: 4px solid #dc3545;
}

/* Responsive adjustments */
@media (max-width: 991px) {
  .interactive-content {
    max-width: 95%;
  }
}

@media (max-width: 767px) {
  .hero-banner {
    height: 300px;
  }
  
  .main-title {
    font-size: 2rem;
    padding: 0 1rem;
  }
  
  .main-subtitle {
    font-size: 1.1rem;
    padding: 0 1rem;
  }
  
  .action-buttons {
    flex-direction: row;
    justify-content: center;
    gap: 1rem;
  }
  
  .action-buttons .btn {
    width: auto;
    max-width: none;
  }
  
  .btn-secondary {
    margin-right: 1rem !important;
    margin-bottom: 0;
  }
}

@media (max-width: 575px) {
  .summary-card {
    padding: 1.2rem;
  }
  
  .summary-title {
    font-size: 1.3rem;
  }
  
  .expectation-icon {
    font-size: 1.5rem;
    min-width: 30px;
  }
  
  .expectation-category {
    font-size: 1.1rem;
  }
  
  .expectation-item,
  .checklist-item {
    padding: 0.8rem;
  }
}
</style>
