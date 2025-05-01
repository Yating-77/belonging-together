<template>
  <div id="app-container">
    <MyNavBar />
    <MyHeroSection data-aos="fade-in" data-aos-duration="1200" />
    <section class="info-grid-section" aria-labelledby="autism-facts-heading">
      <div class="info-grid-container-wrapper">
        <h2 id="autism-facts-heading" class="section-title">Understanding Autism</h2>
        <div class="info-grid-container">
          <MyInfoCard
            v-for="(card, index) in autismIntroCards"
            :key="card.title"
            :title="card.title"
            :description="card.description"
            :imagePath="`/${card.imageName}.jpg`"  
            :colorAccent="card.colorAccent"
            :stat="card.stat"
            data-aos="fade-up"
            :data-aos-delay="index * 100"
            data-aos-duration="1300"
            data-aos-easing="ease-out-cubic"
            data-aos-once="true"
          />
        </div>
        <div class="insights-link-container" data-aos="fade-up" data-aos-delay="300">
          <router-link to="/insights" class="insights-link-button">
            Explore our insights <i class="fas fa-arrow-right"></i>
          </router-link>
        </div>
      </div>
    </section>
      <MyVideoSection />
      
    <section class="navigate-section" aria-labelledby="navigate-heading">
      <div class="navigate-container">
        <div class="navigate-content" data-aos="fade-right" data-aos-duration="1200">
          <h2 id="navigate-heading" class="navigate-title">Navigate the World, Feel You Belong</h2>
          <p class="navigate-subtitle">Every child deserves to feel included in the world around them.</p>
          <p class="navigate-description">
            From a first school tour to a family supermarket trip, these everyday outings can either open doors, or present barriers.
          </p>
          <p class="navigate-description">
            Our Outing Guide and Sensory-Friendly Venues are designed to support inclusion at every step:
            <br>🧭 offering practical tools for preparation,
            <br>🧒 reducing anxiety through environmental previews,
            <br>🎒 and helping your child participate in shared community spaces with confidence.
          </p>
          <p class="navigate-description">
            Together, we create not just smoother outings, but moments of true belonging.
          </p>
          <div class="navigate-buttons">
            <router-link to="/sensoryVenue" class="navigate-button">Find Sensory Venues</router-link>
            <router-link to="/detectpage" class="navigate-button">Explore Outing Guides</router-link>
          </div>
        </div>
        <div class="navigate-image-container" data-aos="fade-left" data-aos-duration="1200">
          <img src="/999.jpg" alt="Child exploring the world" class="navigate-image">
        </div>
      </div>
    </section>
      
    <div
      class="full-width-section background-image-section"
      data-aos="fade-left"
      data-aos-duration="3000"
      data-aos-easing="ease-out-cubic"
      data-aos-once="true"
      data-aos-offset="200"
      data-aos-delay="150"
    >
      <div class="content-wrapper">
        <h2 class="content-item">Resources & Support: Walking With You</h2>
        <p class="content-item">Explore our curated resources, including practical tools, professional guides, family support strategies, and community connection opportunities, as we journey together.</p>
        <router-link to="/resource" class="resource-button content-item">Explore Resource Center</router-link>
      </div>
    </div>
    <MyFooter />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import MyNavBar from '../components/test/MyNavBar.vue';
import MyHeroSection from '../components/test/MyHeroSection.vue';
import MyVideoSection from '../components/test/MyVideoSection.vue';
import MyInfoCard from '../components/test/MyInfoCard.vue'; 
import MyFooter from '../components/test/MyFooter.vue';
import AOS from 'aos';
import 'aos/dist/aos.css';

const router = useRouter();

const autismIntroCards = ref([
  {
    title: "Unique Individual Differences",
    description: "Autism is a broad spectrum, with each child having unique strengths, interests, and support needs. No two individuals are exactly the same.",
    stat: "Did you know? Autism was identified in <strong>3.7%</strong> of Australian children aged 5–9 in 2022 — a steady rise over recent years.",
    imageName: "333",
    colorAccent: "primary"
  },
  {
    title: "Different Ways of Perceiving",
    description: "They may experience sensory information such as sounds, lights, and touch differently. Understanding and respecting these sensory needs is important.",
    stat: "Over <strong>60%</strong> of autistic children experience sensory or social challenges that affect how they perceive the world.",
    imageName: "555",
    colorAccent: "secondary"
  },
  {
    title: "Diverse Communication Methods",
    description: "Communication methods may include language, gestures, pictures, or behaviors. Patient observation and learning their unique expressions is key to building connection.",
    stat: "About <strong>1 in 3</strong> autistic children in Australia have significant speech or language difficulties.",
    imageName: "666",
    colorAccent: "tertiary"
  }
]);

onMounted(() => {
  AOS.init({
    duration: 1200, 
    once: true, 
    offset: 200, 
    easing: 'ease-out-cubic',
    disable: 'phone',
    anchorPlacement: 'center-bottom',
  });
});
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

body {
  font-family: 'Inter', sans-serif; 
  margin: 0; 
  box-sizing: border-box;
  background-color: #f8f9fa; 
  color: #343a40; 
  line-height: 1.7; 
  overflow-x: hidden;
}

*, *::before, *::after { 
  box-sizing: inherit; 
}

#app-container { 
  width: 100%; 
}

h2 { 
  font-size: clamp(1.8rem, 4vw, 2.2rem); 
  font-weight: 700; 
  margin-bottom: 1rem; 
  line-height: 1.3; 
  color: #343a40; 
}

h3 { 
  font-size: 1.25rem; 
  font-weight: 600; 
  margin-bottom: 0.75rem; 
  color: #343a40; 
}

p { 
  font-size: clamp(0.95rem, 2vw, 1.05rem); 
  color: #6c757d; 
  margin-bottom: 2rem; 
  max-width: 65ch; 
  margin-left: auto; 
  margin-right: auto; 
}

.visually-hidden { 
  position: absolute; 
  width: 1px; 
  height: 1px; 
  padding: 0; 
  margin: -1px; 
  overflow: hidden; 
  clip: rect(0, 0, 0, 0); 
  white-space: nowrap; 
  border: 0; 
}

.cta-button { 
  display: inline-block; 
  padding: 12px 28px; 
  border: none; 
  border-radius: 50px; 
  font-size: 1rem; 
  font-weight: 600; 
  text-decoration: none; 
  cursor: pointer; 
  transition: all 0.3s ease; 
  color: #ffffff; 
  letter-spacing: 0.5px; 
}

.cta-button:hover { 
  transform: translateY(-3px); 
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1); 
}

.button-primary { 
  background-color: #3E5C2B; 
}

.button-primary:hover { 
  background-color: #4d7234; 
  color: #ffffff; 
}

.info-grid-section { 
  padding: 5rem 5%; 
  background-color: #F8EFED; 
}

.info-grid-container-wrapper { 
  max-width: 1100px; 
  margin: 0 auto; 
  text-align: center; 
}

.section-title { 
  font-size: clamp(2rem, 5vw, 2.6rem); 
  font-weight: 700; 
  color: #4d2f20; 
  margin-bottom: 3.5rem; 
  line-height: 1.3; 
}

.info-grid-container { 
  display: grid; 
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
  gap: 2.5rem; 
}

.full-width-section { 
  width: 100%; 
  padding: 15rem 5%; 
  margin: 0; 
  text-align: center; 
  border-bottom: 1px solid #dee2e6;
  position: relative;
  overflow: hidden;
}

.full-width-section:last-of-type { 
  border-bottom: none; 
}

.background-image-section {
  background-color: #f8f7f6;
  background-image: url('/777.jpg');
  background-size: cover;
  background-position: center center;
  background-repeat: no-repeat;
  position: relative;
  color: #ffffff;
}

.background-image-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.25);
  z-index: 1;
  transition: background 0.2s linear;
}

.background-image-section:hover::before {
  background: rgba(0, 0, 0, 0.01);
}

.background-image-section .content-wrapper {
  position: relative;
  z-index: 2;
  width: 100%;
  max-width: 900px;
  margin: 0 auto;
}

.background-image-section h2 {
  color: #ffffff;
  text-shadow: 0 2px 6px rgba(0, 0, 0, 0.5);
  font-weight: 700;
}

.background-image-section p {
  color: #ffffff;
  text-shadow: 0 1px 4px rgba(0, 0, 0, 0.5);
  font-weight: 500;
}

.background-image-section .resource-button {
  background-color: #ffffff;
  color: #3E5C2B;
  border: none;
  padding: 14px 32px;
  font-size: 1.05rem;
  font-weight: 600;
  border-radius: 50px;
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
  letter-spacing: 0.5px;
  position: relative;
  z-index: 10;
  cursor: pointer;
  text-decoration: none;
  display: inline-block;
}

.background-image-section .resource-button:hover {
  background-color: #3E5C2B;
  color: #ffffff;
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.content-item {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.8s ease, transform 0.8s ease;
}

.aos-animate .content-item:nth-child(1) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.1s;
}

.aos-animate .content-item:nth-child(2) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.3s;
}

.aos-animate .content-item:nth-child(3) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.5s;
}

@media (max-width: 768px) {
  .full-width-section,
  .background-image-section {
    padding: 4rem 5%;
  }
  
  .background-image-section {
    padding: 8rem 5%;
  }
}

.hero-video-content {
  flex: 1 1 48%;
  min-width: 320px;
  aspect-ratio: 16 / 9;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.hero-text-content {
  flex: 1 1 45%;
  min-width: 280px;
  text-align: left;
}

.hero-text-content h1 {
  font-size: clamp(2rem, 5vw, 2.8rem);
  color: #343a40;
  font-weight: 700;
  margin-bottom: 1.2rem;
}

.hero-subtitle {
  font-size: 1.1rem;
  color: #6c757d;
  line-height: 1.6;
  margin-bottom: 2rem;
}

@media (max-width: 768px) {
  .split-hero-section {
    flex-direction: column;
    padding: 4rem 5%;
  }
  .hero-text-content {
    text-align: center;
  }
}

.navigate-section {
  padding: 4rem 3%;
  background-color: #F8EFED;
  overflow: hidden;
}

.navigate-container {
  max-width: 1300px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 2rem;
}

.navigate-image-container {
  flex: 1.2;
  min-width: 380px;
  padding-left: 2rem;
  padding-right: 0;
}

.navigate-image {
  width: 100%;
  border-radius: 12px;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  transform: perspective(1000px) rotateY(5deg);
  transition: transform 0.5s ease;
}

.navigate-image:hover {
  transform: perspective(1000px) rotateY(0deg);
}

.navigate-content {
  flex: 0.8;
  min-width: 320px;
}

.navigate-title {
  font-size: clamp(1.8rem, 4vw, 2.2rem);
  font-weight: 700;
  color: #4d2f20;
  margin-bottom: 1rem;
}

.navigate-subtitle {
  font-size: 1.2rem;
  font-weight: 600;
  color: #4d2f20;
  margin-bottom: 1rem;
}

.navigate-description {
  font-size: 1rem;
  color: #6c757d;
  margin-bottom: 1rem;
  line-height: 1.8;
}

.navigate-buttons {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
  width: 100%;
}

.navigate-button {
  flex: 1;
  padding: 12px 24px;
  background-color: #3E5C2B;
  color: white;
  border: none;
  border-radius: 50px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  text-align: center;
  white-space: nowrap;
  min-width: 220px;
}

.navigate-button:hover {
  background-color: #4d7234;
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

@media (max-width: 1100px) {
  .navigate-container {
    gap: 1.5rem;
  }
  
  .navigate-image-container {
    padding-left: 1rem;
  }
}

@media (max-width: 992px) {
  .navigate-section {
    padding: 3.5rem 4%;
  }
  
  .navigate-container {
    flex-direction: column;
    gap: 2.5rem;
  }
  
  .navigate-content {
    order: 1;
    text-align: center;
    max-width: 90%;
  }
  
  .navigate-image-container {
    order: 2;
    width: 80%;
    max-width: 500px;
    margin: 0 auto;
    padding-left: 0;
  }
  
  .navigate-buttons {
    justify-content: center;
  }
}

@media (max-width: 768px) {
  .navigate-section {
    padding: 3rem 5%;
  }
  
  .navigate-title {
    font-size: 1.6rem;
  }
  
  .navigate-subtitle {
    font-size: 1.1rem;
  }
  
  .navigate-image-container {
    width: 90%;
  }
  
  .navigate-buttons {
    flex-direction: column;
    gap: 1rem;
  }
  
  .navigate-button {
    width: 100%;
  }
}

@media (max-width: 480px) {
  .navigate-section {
    padding: 2.5rem 4%;
  }
  
  .navigate-content {
    max-width: 100%;
  }
  
  .navigate-image-container {
    width: 95%;
    min-width: auto;
  }
  
  .navigate-description {
    font-size: 0.95rem;
  }
}

.insights-link-container {
  margin-top: 3rem;
  text-align: center;
}

.insights-link-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background-color: #3E5C2B;
  color: white;
  padding: 14px 32px;
  border-radius: 50px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  gap: 10px;
}

.insights-link-button i {
  font-size: 0.9rem;
  transition: transform 0.3s ease;
}

.insights-link-button:hover {
  background-color: #4d7234;
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

.insights-link-button:hover i {
  transform: translateX(4px);
}

@media (max-width: 768px) {
  .insights-link-container {
    margin-top: 2rem;
  }
  
  .insights-link-button {
    padding: 12px 28px;
  }
}
</style>