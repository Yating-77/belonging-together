<template>
  <!-- Main container with THEMED background -->
  <div class="outside-scene-page">

    <MyNavBar />

    <!-- ===== NEW: Intro Section ===== -->
    <div class="hero-banner">
      <div class="hero-image-container">
        <img
          src="/detect-image.png"
          alt="Illustration for preparing for outings"
          class="hero-image"
        />
      </div>
      <div class="hero-text-overlay">
        <div class="container text-center">
          <h1 class="main-title">Prepare for a Successful Outing</h1>
          <p class="main-subtitle">
            Help your child feel confident and calm before exploring outdoor places like playgrounds, cinemas, or community events.
            Explore what they might see, hear, and feel—and what you can bring to support them.
          </p>
        </div>
      </div>
    </div>
    <!-- ===== End Intro Section ===== -->


    <!-- ===== Interactive Section ===== -->
    <div class="interactive-section-container container my-4">
        <!-- Center the content within this section -->
        <div class="interactive-content mx-auto">

          <!-- Introduction Text -->
          <div class="scene-intro-card mb-4">
            <div class="card-body">
              <h4 class="fw-bold mb-3">Prepare Your Child for Different Environments</h4>
              <p>We've created guides for several common scenarios that might be challenging for children with sensory sensitivities:</p>
              <ul>
                <li><strong>Medical Visit</strong> - Doctor and dentist appointments</li>
                <li><strong>Airport Travel</strong> - Navigating airports and flying</li>
                <li><strong>Leisure Outing</strong> - Parks, cinemas and public spaces</li>
                <li><strong>School Visit</strong> - Classroom and school environments</li>
              </ul>
              <p class="mb-0">Select a scenario above to explore what your child might experience and learn how to prepare step by step.</p>
            </div>
          </div>
          
          <!-- Scene Selection Dropdown -->
          <div class="mb-4">
            <label for="sceneSelect" class="form-label fw-bold label-text">1. Select a Scene:</label>
            <select id="sceneSelect" class="form-select form-select-lg dropdown-select" v-model="selectedSceneId">
              <option :value="null" disabled>-- Choose a scene --</option>
              <option v-for="scene in frontendScenes" :key="scene.id" :value="scene.id">
                {{ scene.name }}
              </option>
            </select>
          </div>

          <!-- Display Backend Error -->
           <div v-if="error" class="alert alert-danger error-box" role="alert">
             <strong>Error:</strong> {{ error }}
             <p class="mb-0 mt-1"><small>Could not load details for the selected scene. Please check the backend or try again later.</small></p>
        </div>
        
          <!-- Dynamic Content Area (Shows after selection) -->
          <div v-if="selectedSceneId" class="dynamic-content-area mt-4">

             <!-- Scene Title and Subtitle (Smaller) -->
            <div class="title-section mb-3 text-center">
              <transition name="fade" mode="out-in">
                 <div v-if="selectedSceneDetails" :key="'details-' + selectedSceneDetails.id">
                    <h2 class="scene-content-title">{{ selectedSceneDetails.title }}</h2>
                    <p class="scene-content-subtitle">{{ selectedSceneDetails.subtitle }}</p>
        </div>
              </transition>
        </div>
        
            <!-- Loading Indicator -->
            <div v-if="isLoading" class="text-center my-3">
              <div class="spinner-border spinner-border-sm text-primary-custom" role="status"> <span class="visually-hidden">Loading...</span> </div>
              <p class="loading-text small mt-1">Loading sensory details...</p>
        </div>
        
            <!-- What to Expect Section -->
            <div v-if="!isLoading && !error && sensoryExpectations.length > 0" class="expectations-section mt-3">
              <h4 class="label-text fw-bold">2. What to Expect in the Environment</h4>
              
              <!-- Card Container with Scene Background -->
              <div class="expectations-container-wide" :class="'scene-bg-' + selectedSceneId">
                <div class="expectations-list d-flex flex-column justify-content-between h-100">
                  <div v-for="(item, index) in sensoryExpectations" :key="item.id"
                       class="expectation-item card">
                       <div class="card-body d-flex align-items-start p-3">
                         <span class="expectation-icon me-3 fs-4">{{ getIconForCategory(item.category) }}</span>
                         <div>
                            <h5 class="expectation-category mb-1 text-capitalize">{{ item.category }}</h5>
                            <p class="expectation-description mb-0">{{ item.description }}</p>
                         </div>
                       </div>
                  </div>
                </div>
              </div>
              
              <!-- Next Button -->
              <div class="text-center mt-4">
                  <button class="btn btn-action btn-lg" @click="goToNext" :disabled="!selectedSceneId">
                      Next Step →
              </button>
        </div>
      </div>
      
             <!-- Message if no expectations found -->
             <div v-else-if="!isLoading && !error && sensoryExpectations.length === 0" class="alert alert-info mt-4 info-box">
                No specific sensory expectations were found for this scene.
      </div>
          </div> <!-- End Dynamic Content Area -->

        </div> <!-- End interactive-content -->
    </div> <!-- End interactive-section-container -->

    <MyFooter />
    </div>
  </template>
  
<script setup>
// Script content remains IDENTICAL
import { ref, onMounted, watch, computed } from 'vue';
import axios from 'axios';
import AOS from 'aos';
import 'aos/dist/aos.css';
import MyNavBar from '../components/test/MyNavBar.vue';
import MyFooter from '../components/test/MyFooter.vue';
import { useRouter } from 'vue-router';

const frontendScenes = ref([ { id: 1, name: 'Medical Visit', title: 'Going to the Doctor/Dentist', subtitle: 'Preparing for a check-up or appointment.' }, { id: 2, name: 'Airport Travel', title: 'Traveling by Plane', subtitle: 'Navigating the airport environment.' }, { id: 3, name: 'Leisure Outing', title: 'Visiting a Park or Cinema', subtitle: 'Enjoying community spaces and events.' }, { id: 4, name: 'School Visit', title: 'Going to School', subtitle: 'Getting ready for the classroom setting.' } ]);
const selectedSceneId = ref(null); const sensoryExpectations = ref([]); const isLoading = ref(false); const error = ref(null);
const API_BASE_URL = 'http://localhost:3000/api';
const router = useRouter();

const selectedSceneDetails = computed(() => { if (!selectedSceneId.value) return null; return frontendScenes.value.find(scene => scene.id === selectedSceneId.value) || null; });

const fetchSensoryExpectations = async (sceneId) => { if (!sceneId) { sensoryExpectations.value = []; return; } isLoading.value = true; error.value = null; sensoryExpectations.value = []; console.log("Fetching expectations for scene ID:", sceneId); try { const response = await axios.get(`${API_BASE_URL}/scenes/${sceneId}/sensory-expectations`); console.log("Fetch expectations response:", response); if (response.data.success && Array.isArray(response.data.data)) { sensoryExpectations.value = response.data.data; console.log("Expectations loaded:", sensoryExpectations.value.length); } else { throw new Error(response.data.error || 'Invalid data format received for expectations'); } } catch (err) { console.error(`Error fetching sensory expectations for scene ${sceneId}:`, err); let message = `Could not load sensory details for "${selectedSceneDetails.value?.name || 'this scene'}". `; if (err.response) { message += `Server responded with status ${err.response.status}.`; if (err.response.data?.details) { message += ` Details: ${err.response.data.details}`; } else if (err.response.data?.error) { message += ` Message: ${err.response.data.error}`; } } else if (err.request) { message += ' No response from server.'; } else { message += ` Error: ${err.message}`; } error.value = message; sensoryExpectations.value = []; } finally { isLoading.value = false; } };
const getIconForCategory = (category) => { switch (category?.toLowerCase()) { case 'hearing': return '👂'; case 'sight': return '💡'; case 'smell': return '👃'; case 'touch': return '🖐️'; default: return '🧠'; } };
const goToNext = () => {
  if (!selectedSceneId.value) return;
  console.log('Navigating to next step for scene ID:', selectedSceneId.value);
  router.push({
    path: '/detectImage',
    query: { sceneId: selectedSceneId.value }
  });
};
onMounted(() => { AOS.init({ duration: 600, once: false, offset: 50 }); });
watch(selectedSceneId, (newId) => { console.log(`Selected scene ID changed to ${newId}`); if (newId !== null) { sensoryExpectations.value = []; error.value = null; fetchSensoryExpectations(newId); } else { sensoryExpectations.value = []; error.value = null; isLoading.value = false; } });
  </script>
  
  <style scoped>
/* Core theme colors */
:root {
  --background-main: #F8EFED;
  --text-brown: #4d2f20;
  --primary-green: #3E5C2B;
  --card-bg: #FFFFFF;
  --border-color: #e0e0e0;
}

/* 全局页面背景 */
.outside-scene-page {
  background-color: #F8EFED !important;
  min-height: 100vh;
  width: 100%;
  display: flex;
  flex-direction: column;
}

/* Hero Banner 样式 */
.hero-banner {
  position: relative;
  width: 100%;
  height: 500px;
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
  color: #4d2f20 !important;
  font-size: 2.7rem;
  font-weight: 700;
  margin-bottom: 1rem;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

.main-subtitle {
  color: #4d2f20 !important;
  font-size: 1.3rem;
  margin-bottom: 0;
  line-height: 1.6;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

/* ===== Interactive Section Styling ===== */
.interactive-section-container {
  flex-grow: 1;
  padding-bottom: 3rem;
  background-color: #F8EFED;
}

.interactive-content {
  max-width: 700px;
  width: 100%;
}

/* Label and Dropdown */
.label-text { 
  color: #4d2f20 !important; 
  font-size: 1.1rem; 
  margin-bottom: 0.5rem; 
  font-weight: 600;
  text-align: left;
}

.dropdown-select {
  border: 2px solid #3E5C2B !important;
  border-radius: 8px;
  padding: 0.75rem 1.25rem;
  font-size: 1.1rem;
  background-color: white;
  color: #4d2f20 !important;
  box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    cursor: pointer;
  }
  
.dropdown-select:focus { 
  border-color: #3E5C2B !important; 
  box-shadow: 0 0 0 0.25rem rgba(62, 92, 43, 0.25);
}

/* 自定义下拉箭头与背景 */
select.dropdown-select {
  background-image: linear-gradient(45deg, transparent 50%, #3E5C2B 50%), 
                    linear-gradient(135deg, #3E5C2B 50%, transparent 50%);
  background-position: calc(100% - 20px) center, calc(100% - 15px) center;
  background-size: 5px 5px, 5px 5px;
  background-repeat: no-repeat;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
}

/* 覆盖下拉菜单选项样式 - 尝试强制样式 */
select option {
  background-color: #F8EFED !important;
  color: #4d2f20 !important;
  padding: 12px !important;
}

/* 选中项样式 */
select option:checked {
  background-color: #3E5C2B !important;
  color: white !important;
  box-shadow: 0 0 10px 100px #3E5C2B inset !important;
  -webkit-text-fill-color: white !important;
}

/* Dynamic Area below dropdown */
.dynamic-content-area { 
  min-height: 200px;
  margin-top: 2rem;
}

.scene-content-title {
  color: #4d2f20 !important;
  font-size: 1.6rem;
  font-weight: 600;
}

.scene-content-subtitle {
  color: #4d2f20 !important;
  font-size: 1.0rem;
  opacity: 0.9;
  line-height: 1.5;
}

/* Loading and Error styling */
.text-primary-custom { color: #3E5C2B !important; }
.loading-text { color: #4d2f20 !important; opacity: 0.8; }
.error-box { 
  border-radius: 8px; 
  padding: 0.8rem 1.25rem; 
  background-color: #f8d7da; 
  border-color: #f5c6cb; 
  color: #721c24; 
  margin-top: 1rem;
}
.error-box strong { color: #721c24; }
.info-box { 
  border-radius: 8px; 
  padding: 1rem 1.25rem; 
  background-color: #e2f3fd; 
  border-color: #b8e7fb; 
  color: #0c5464; 
  margin-top: 1rem;
}

/* Expectations section styling */
.expectations-section { margin-top: 2rem; }

/* 宽屏卡片容器 */
.expectations-container-wide {
  width: 100%;
  min-height: 400px;
  margin-bottom: 2rem;
  margin-top: 2rem;
  background-color: rgba(248, 249, 250, 0.4);
  background-size: cover;
  background-position: center;
  position: relative;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  overflow: hidden;
  padding: 1.5rem;
}

.expectations-list {
  padding: 1rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.expectation-item.card {
  background-color: rgba(255, 255, 255, 0.95);
  border: none;
  border-left: 4px solid #3E5C2B;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
  margin-bottom: 1rem;
  max-width: 600px;
}

.expectation-item.card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 16px rgba(0,0,0,0.12);
}

.expectation-icon { 
  color: #3E5C2B !important;
  font-size: 1.8rem;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 40px;
}

.expectation-category {
  color: #3E5C2B !important; 
  font-weight: 600;
  font-size: 1.2rem;
  margin-bottom: 0.5rem;
}

.expectation-description {
  color: #4d2f20 !important; 
  font-size: 1rem; 
  line-height: 1.5;
}

/* Button styling */
.btn-action {
  background-color: #3E5C2B !important; 
  color: white !important;
  font-size: 1.1rem;
  border-radius: 8px;
  transition: all 0.3s ease;
  border: 2px solid #3E5C2B !important;
  padding: 0.75rem 1.5rem;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.btn-action:hover:not(:disabled) { 
  background-color: #314a22 !important; 
  border-color: #314a22 !important;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.2);
  transform: translateY(-2px);
}

.btn-action:disabled { 
  background-color: #3E5C2B !important;
  border-color: #3E5C2B !important;
  opacity: 0.7;
  cursor: not-allowed;
  color: white !important;
}

/* Transitions */
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* Responsive adjustments */
@media (max-width: 991px) {
  .interactive-content {
    max-width: 95%;
  }
  
  .hero-banner {
    height: 400px;
  }
  
  .hero-image {
    height: 100%;
  }
  
  .main-title {
    font-size: 2.2rem;
  }
  
  .main-subtitle {
    font-size: 1.1rem;
  }
}

@media (max-width: 767px) {
  .hero-banner {
    height: 300px;
  }
  
  .main-title {
    font-size: 1.8rem;
    padding: 0 1rem;
  }
  
  .main-subtitle {
    font-size: 1rem;
    padding: 0 1rem;
  }
  
  .expectations-container-wide {
    min-height: auto;
    padding: 1rem;
  }
  
  .expectation-item.card {
    margin-bottom: 0.8rem;
  }
  
  .expectation-category {
    font-size: 1.1rem;
  }
  
  .expectation-description {
    font-size: 0.95rem;
  }
  
  .expectation-icon {
    font-size: 1.5rem;
    min-width: 30px;
  }
}

@media (max-width: 575px) {
  .scene-intro-card .card-body {
    padding: 1.2rem;
  }
  
  .expectation-icon {
    margin-right: 0.5rem !important;
  }
  
  .label-text {
    font-size: 1rem;
  }
  
  .scene-content-title {
    font-size: 1.4rem;
  }
  
  .expectation-item.card .card-body {
    padding: 0.8rem;
  }
}

/* 介绍卡片样式 */
.scene-intro-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  margin-bottom: 2rem;
  border: 1px solid #e0e0e0;
}

.scene-intro-card .card-body {
  padding: 1.5rem;
}

.scene-intro-card h4 {
  color: #4d2f20;
}

.scene-intro-card p, .scene-intro-card ul {
  color: #4d2f20;
  font-size: 1rem;
  line-height: 1.5;
}

.scene-intro-card ul {
  margin-bottom: 1.5rem;
  padding-left: 1.5rem;
}

.scene-intro-card li {
  margin-bottom: 0.5rem;
}

/* 感官卡片容器样式 */
.expectations-container {
  background-color: #f8f9fa;
  border-radius: 10px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  border: 1px solid #e0e0e0;
}

/* 场景背景样式 */
.scene-bg-1 {
  background-image: url('/scenes/medical-bg.png');
}

.scene-bg-2 {
  background-image: url('/scenes/airplane-bg.png');
}

.scene-bg-3 {
  background-image: url('/scenes/park-bg.png');
}

.scene-bg-4 {
  background-image: url('/scenes/school-bg.png');
}
  </style>