<template>
 
  <section class="hero-slideshow">

    
    <div class="slideshow-container">

      <!-- Slide 1 -->
      <div class="slideshow-slide" :class="{ active: currentSlide === 0 }">
        
        <div class="hero-text-content" data-aos="fade-right" data-aos-delay="100">
          <h1 class="hero-title">Built for families of autistic children.</h1>
          <p class="hero-subtitle">
            Whether you're facing bedtime battles or communication challenges, we're here with clear, kind, and practical support.
          </p>
          <div class="hero-actions">
           
            <router-link to="/resource" class="cta-button button-secondary">Explore Our Resources</router-link>
          </div>
        </div>

        
        <div class="hero-visual-content" data-aos="fade-left" data-aos-delay="100">
          <img src="/slideshow-1.png" alt="Support for families with autistic children" class="slideshow-image">
        </div>
      </div>

      <!-- Slide 2 -->
      <div class="slideshow-slide" :class="{ active: currentSlide === 1 }">
        
        <div class="hero-text-content" data-aos="fade-right" data-aos-delay="100">
          <h1 class="hero-title">We see you.</h1>
          <h1 class="hero-title">We support you.</h1>
          <p class="hero-subtitle">
            Tell us about your child's daily experiences: bedtime, meals, emotions, play. And we'll give you gentle, clear suggestions to support their growth. All free. All backed by science. All with love.
          </p>
          <div class="hero-actions">
           
            <router-link to="/intro" class="cta-button button-secondary">Get Personalised Recommendations</router-link>
          </div>
        </div>

     
        <div class="hero-visual-content" data-aos="fade-left" data-aos-delay="100">
          <img src="/222.jpg" alt="We support families" class="slideshow-image">
        </div>
      </div>

      <!-- Slide 3 -->
      <div class="slideshow-slide" :class="{ active: currentSlide === 2 }">
        
        <div class="hero-text-content" data-aos="fade-right" data-aos-delay="100">
          <h1 class="hero-title">Together, we promote social inclusion.</h1>
          <p class="hero-subtitle">
            We help every child feel seen, heard, and included at home, in school, and in the community.
          </p>
          <div class="hero-actions">
            
            <router-link to="/resource" class="cta-button button-secondary">Explore Our Resources</router-link>
          </div>
        </div>

       
        <div class="hero-visual-content" data-aos="fade-left" data-aos-delay="100">
          <img src="/slideshow-2.jpg" alt="Social inclusion for children" class="slideshow-image">
        </div>
      </div>
    </div>

    
    <button class="slide-nav prev" @click="prevSlide" aria-label="Previous slide">&#10094;</button>
    <button class="slide-nav next" @click="nextSlide" aria-label="Next slide">&#10095;</button>
    
   
    <div class="slideshow-indicators">
      <span 
        v-for="(_, index) in slides" 
        :key="index" 
        class="indicator" 
        :class="{ active: currentSlide === index }" 
        @click="goToSlide(index)">
      </span>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue';

const slides = [
  {
    title: "Built for families of autistic children.",
    subtitle: "Whether you're facing bedtime battles or communication challenges, we're here with clear, kind, and practical support.",
    image: "/slideshow-1.png",
    cta: "Explore Our Resources",
    link: "/resource"
  },
  {
    title: "We see you. We support you.",
    subtitle: "Tell us about your child's daily experiences: bedtime, meals, emotions, play. And we'll give you gentle, clear suggestions to support their growth. All free. All backed by science. All with love.",
    image: "/222.jpg",
    cta: "Get Personalised Recommendations",
    link: "/recommendation"
  },
  {
    title: "Together, we promote social inclusion.",
    subtitle: "We help every child feel seen, heard, and included at home, in school, and in the community.",
    image: "/slideshow-2.jpg",
    cta: "Explore Our Resources",
    link: "/resource"
  }
];

const currentSlide = ref(0);

const nextSlide = () => {
  currentSlide.value = (currentSlide.value + 1) % slides.length;
};

const prevSlide = () => {
  currentSlide.value = (currentSlide.value - 1 + slides.length) % slides.length;
};

const goToSlide = (index) => {
  currentSlide.value = index;
};
</script>

<style scoped>
.hero-slideshow {
  position: relative;
  min-height: 80vh;
  background-color: #ffffff;
  overflow: hidden;
}

.slideshow-container {
  width: 100%;
  height: 100%;
}

.slideshow-slide {
  display: flex;
  min-height: 80vh;
  opacity: 0;
  transition: opacity 0.5s ease-in-out;
  position: absolute;
  width: 100%;
  top: 0;
  left: 0;
}

.slideshow-slide.active {
  opacity: 1;
  position: relative;
}

.hero-text-content {
  flex: 1 1 55%; 
  padding: 5rem 7% 5rem 5%; 
  display: flex; 
  flex-direction: column;
  justify-content: center; 
  align-items: flex-start; 
  text-align: left;
  z-index: 2;
}

.hero-title {
  font-size: clamp(2.5rem, 5.5vw, 3.5rem); 
  font-weight: 700; 
  color: #4d2f20; 
  margin-bottom: 1.5rem; 
  line-height: 1.25;
}

.hero-subtitle {
  font-size: clamp(1rem, 2.5vw, 1.15rem); 
  color: #6c757d;
  margin-bottom: 3rem; 
  margin-top: 2.5rem; 
  max-width: 580px; 
  margin-left: 0; 
  margin-right: 0;
}

.hero-actions { 
  display: flex; 
  flex-wrap: wrap; 
  gap: 1rem; 
  margin-bottom: 3rem; 
}

.hero-visual-content {
  flex: 1 1 45%; 
  position: relative; 
  min-height: 350px;
  clip-path: polygon(12% 0, 100% 0, 100% 100%, 0 100%);/**Creates the angled corner visual effect */
  display: flex; 
  align-items: center; 
  justify-content: center; 
  overflow: hidden;
}

.slideshow-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.slide-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 50px;
  height: 50px;
  background-color: rgba(255, 255, 255, 0.6);
  border: none;
  border-radius: 50%;
  cursor: pointer;
  font-size: 18px;
  font-weight: bold;
  z-index: 3;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.slide-nav:hover {
  background-color: rgba(255, 255, 255, 0.9);
}

.prev {
  left: 20px;
}

.next {
  right: 20px;
}

.slideshow-indicators {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 10px;
  z-index: 3;
}

.indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #999999;
  cursor: pointer;
  transition: background-color 0.3s ease;
  border: 1px solid #666666;
}

.indicator.active {
  background-color: #3E5C2B;
  border: 2px solid #ffffff;
}

@media (max-width: 992px) {
  .slideshow-slide { 
    flex-direction: column-reverse; 
    min-height: auto; 
  }
  
  .hero-text-content { 
    flex-basis: auto; 
    padding: 4rem 5%; 
    text-align: center; 
    align-items: center; 
  }
  
  .hero-title { font-size: clamp(2.2rem, 7vw, 3rem); }
  .hero-subtitle { margin-left: auto; margin-right: auto; font-size: clamp(1rem, 3vw, 1.1rem); }
  .hero-actions { justify-content: center; margin-bottom: 2.5rem; }
  
  .hero-visual-content { 
    flex-basis: auto; 
    min-height: 40vh; 
    width: 100%; 
    clip-path: none; 
  }

  .slide-nav {
    width: 40px;
    height: 40px;
    font-size: 16px;
  }
}

.cta-button { display: inline-block; padding: 12px 28px; border: none; border-radius: 50px; font-size: 1rem; font-weight: 600; text-decoration: none; cursor: pointer; transition: all 0.3s ease; color: #ffffff; letter-spacing: 0.5px; }
.cta-button:hover { transform: translateY(-3px); box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1); }
.button-secondary { background-color: #3E5C2B; } 
.button-secondary:hover { background-color: #4d7234; color: #ffffff; } 

.cta-button.secondary { background-color: transparent; border: 2px solid; }
.button-secondary-outline { border-color: #3E5C2B; color: #3E5C2B; } 
.button-secondary-outline:hover { background-color: #3E5C2B; color: #ffffff; border-color: #3E5C2B;} 
</style>