<template>
    <MyNavBar /> 
  <div class="thank-you-page-container">
    <div class="results-container">
      <div class="results-card card border-0 shadow-sm p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h1 class="results-title">Thank You</h1>
          <div>
            <button class="btn handbook-button" @click="showSummary = true">
              📚 View Complete Handbook
            </button>
          </div>
        </div>

        <div class="thank-you-section mb-4 p-3">
          <h3 class="mb-4 text-center">To Parents</h3>
          <p class="mb-4">
            Every child is a unique universe. In their journey of growth, there may be anxiety,
            sensitivity, or different ways of expression.
          </p>
          <p class="mb-4">
            We hope these gentle scenarios can serve as a bridge of understanding and
            connection between you and your child.
          </p>
          <p class="mb-4">
            May you feel trust, strength, and love in every moment of companionship.
          </p>
          <p class="text-end mb-2">
            — Belonging Together Team ❤️
          </p>
        </div>

        <div class="d-flex justify-content-start mt-4">
          <button class="btn back-button" @click="goBack">
            Back
          </button>
        </div>
      </div>
    </div>

    <!-- Summary Modal -->
    <div v-if="showSummary" class="summary-modal" @keydown.escape="showSummary = false">
      <div class="summary-content" style="max-width: 1200px; width: 95%;">
        <div class="modal-header">
          <h3 class="modal-title">Parent Handbook Generator</h3>
          <button type="button" class="close-btn" @click="showSummary = false">&times;</button>
        </div>
        <div class="modal-body">
          <Summary></Summary>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn back-button" @click="showSummary = false">Return</button>
        </div>
      </div>
    </div>

   
  </div>
  <MyFooter />
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import MyNavBar from '@/components/test/MyNavBar.vue'; 
import MyFooter from '@/components/test/MyFooter.vue';
import Summary from '@/components/Summary.vue';

const router = useRouter();
const showSummary = ref(false);

const viewHandbook = () => {
  showSummary.value = true;
};

const goBack = () => {
  router.push('/recommendation');
};
</script>

<style scoped>
.thank-you-page-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #F8EFED;
  padding-top: 2rem;
  padding-bottom: 2rem;
}

.results-container {
  flex-grow: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  padding: 1rem;
}

.results-card {
  background-color: #FFFFFF;
  border-radius: 15px;
  width: 100%;
  max-width: 800px;
  padding: 2rem;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.results-title {
  color: #4d2f20;
  font-size: 2.2rem;
  font-weight: bold;
}

.handbook-button {
  background-color: #3E5C2B;
  color: white;
  border-radius: 8px;
  padding: 10px 20px;
  border: none;
  transition: all 0.3s ease;
}

.handbook-button:hover {
  background-color: #3E5C2B;
  box-shadow: 0 4px 10px rgba(77, 47, 32, 0.3);
  transform: translateY(-2px);
}

.thank-you-section {
  background-color: #f9f7f6;
  border-radius: 15px;
  border-left: 4px solid #3E5C2B;
  padding: 2rem !important;
  box-shadow: 0 3px 10px rgba(0,0,0,0.05);
}

.thank-you-section h3 {
  color: #3E5C2B;
  font-size: 1.8rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}

.thank-you-section p {
  font-size: 1.1rem;
  line-height: 1.8;
  color: #4d2f20;
}

.back-button {
  background-color: #5a6268;
  color: white;
  border-radius: 8px;
  padding: 10px 20px;
  border: none;
  transition: all 0.3s ease;
}

.back-button:hover {
  background-color: #444b52;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

.summary-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.summary-content {
  background-color: #ffffff;
  width: 95%;
  height: 95vh;
  max-width: 1400px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e0e0e0;
  background-color: #F7F0ED;
}

.modal-title {
  color: #3E5C2B;
  margin: 0;
  font-size: 1.5rem;
}

.close-btn {
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  color: #4d2f20;
  transition: all 0.2s ease;
}

.close-btn:hover {
  transform: scale(1.1);
  color: #3E5C2B;
}

.modal-body {
  padding: 0;
  flex: 1;
  overflow-y: auto;
}

.modal-footer {
  padding: 1rem 1.5rem;
  border-top: 1px solid #e0e0e0;
  display: flex;
  justify-content: flex-end;
  background-color: #F7F0ED;
}
</style>