<template>
  <div :class="['my-info-card', colorClass]" data-aos="fade-up">
    <div class="info-card-image-wrapper">
      <img :src="imagePath" :alt="title" class="info-card-image">
    </div>
    <h3 class="info-card-title">{{ title }}</h3>
    <p class="info-card-description">{{ description }}</p>
    <div v-if="stat" class="info-card-stat" v-html="stat"></div>
  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  title: { type: String, required: true },
  description: { type: String, required: true },
  imagePath: { type: String, required: true },
  colorAccent: { type: String, default: 'primary' },
  stat: { type: String, default: '' }
});

const colorClass = computed(() => `accent-${props.colorAccent}`);

</script>

<style scoped>
.my-info-card {
  background-color: #ffffff;
  padding: 1.5rem;
  border-radius: 20px; 
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.07);
  text-align: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  overflow: hidden;
}
.my-info-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 35px rgba(0, 0, 0, 0.1);
}

.my-info-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 6px;
  border-top-left-radius: 20px;
  border-bottom-left-radius: 20px;
  transition: all 0.3s ease;
}
.my-info-card.accent-primary::before {
  background-color: #88bf10;
  box-shadow: 0 0 15px rgba(12, 166, 120, 0.4);
}

.my-info-card.accent-secondary::before {
  background-color: #c76d0c;
  box-shadow: 0 0 15px rgba(255, 166, 0, 0.4);
}

.my-info-card.accent-tertiary::before {
  background-color: #ff4000;
  box-shadow: 0 0 15px rgba(247, 103, 7, 0.4);
}
.info-card-image-wrapper {
  margin-bottom: 1.8rem;
  width: 150px;        
  height: 150px;       
  overflow: hidden;
  border-radius: 16px;  
  background-color: #f0f0f0; 
}


.info-card-image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover; 
}


.info-card-title {
  font-size: 1.25rem; 
  font-weight: 600;
  margin-bottom: 0.6rem;
  color: #343a40;
}
.my-info-card.accent-primary h3 {
   color: #88bf10; 
}
.my-info-card.accent-secondary h3 {
   color: #c76d0c; 
}
.my-info-card.accent-tertiary h3 {
   color: #ff4000; 
}

.info-card-description {
  font-size: 0.95rem;
  color: #6c757d;
  margin-bottom: 1rem;
  flex-grow: 1;
  line-height: 1.6; 
}

.info-card-stat {
  font-size: 0.9rem;
  background-color: #f8f9fa;
  border-radius: 10px;
  padding: 12px 15px;
  margin-top: auto;
  text-align: left;
  color: #4d2f20;
  border-left: 3px solid;
  line-height: 1.5;
  font-style: italic;
}

.my-info-card.accent-primary .info-card-stat {
  border-left-color: #88bf10;
  background-color: rgba(136, 191, 16, 0.1);
}

.my-info-card.accent-secondary .info-card-stat {
  border-left-color: #c76d0c;
  background-color: rgba(199, 109, 12, 0.1);
}

.my-info-card.accent-tertiary .info-card-stat {
  border-left-color: #ff4000;
  background-color: rgba(255, 64, 0, 0.1);
}
</style>