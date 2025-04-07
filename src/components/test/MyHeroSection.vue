<template>
  <section class="split-hero-section">
    <div class="hero-text-content" data-aos="fade-right" data-aos-delay="100">
      <h1 class="hero-title">Get Personalized Strategies for Effective Communication with Your Child</h1>
      <p class="hero-subtitle">
        Enter your child's behavioral characteristics to receive practical growth advice; learn effective communication skills to easily understand your child's needs. Simple, practical, and based on care.
      </p>
      <div class="hero-actions">
        <router-link to="/recommendation" class="cta-button button-secondary">Get Personalized Recommendations</router-link>
      </div>
    </div>
    <div class="hero-visual-content" data-aos="fade-left" data-aos-delay="100">
    </div>
  </section>
</template>

<script setup>
// No additional script needed, router-link is automatically handled by Vue Router
</script>

<style scoped> /* Added scoped */
.split-hero-section {
  display: flex; min-height: 80vh; background-color: #ffffff; /* White */ overflow: hidden;
}
.hero-text-content {
  flex: 1 1 55%; padding: 5rem 7% 5rem 5%; display: flex; flex-direction: column;
  justify-content: center; align-items: flex-start; text-align: left;
}
.hero-title {
  font-size: clamp(2.5rem, 5.5vw, 3.5rem); font-weight: 700; color: #343a40; /* Dark gray */
  margin-bottom: 1.5rem; line-height: 1.25;
}
.hero-subtitle {
  font-size: clamp(1rem, 2.5vw, 1.15rem); color: #6c757d; /* Slightly lighter gray */
  margin-bottom: 2.5rem; max-width: 580px; margin-left: 0; margin-right: 0;
}
.hero-actions { display: flex; flex-wrap: wrap; gap: 1rem; margin-bottom: 3rem; }
.hero-stats { margin-top: auto; padding-top: 1.5rem; border-top: 1px solid #dee2e6; /* Light gray border */ align-self: stretch; }
.stat-number { font-size: clamp(2rem, 5vw, 2.8rem); font-weight: 700; color: #15b371; /* Changed to green */ margin-right: 0.5rem; line-height: 1; }
.stat-label { font-size: 0.9rem; color: #6c757d; }
.hero-visual-content {
  flex: 1 1 45%; position: relative; min-height: 350px;
  background-image: url('/222.jpg'); background-size: cover; background-position: center center; background-repeat: no-repeat;
  clip-path: polygon(12% 0, 100% 0, 100% 100%, 0 100%);
  display: flex; align-items: flex-end; justify-content: flex-end; padding: 2rem;
}
.visual-overlay-text { color: rgba(255, 255, 255, 0.85); font-weight: 600; font-size: 1rem; text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5); }

@media (max-width: 992px) {
  .split-hero-section { flex-direction: column-reverse; min-height: auto; }
  .hero-text-content { flex-basis: auto; padding: 4rem 5%; text-align: center; align-items: center; }
  .hero-title { font-size: clamp(2.2rem, 7vw, 3rem); }
  .hero-subtitle { margin-left: auto; margin-right: auto; font-size: clamp(1rem, 3vw, 1.1rem); }
  .hero-actions { justify-content: center; margin-bottom: 2.5rem; }
  .hero-stats { margin-top: 2.5rem; align-self: center; text-align: center; border-top: none; }
  .hero-visual-content { flex-basis: auto; min-height: 40vh; width: 100%; clip-path: none; align-items: center; justify-content: center; padding: 1rem; }
  .visual-overlay-text { font-size: 1.1rem; }
}

/* Added local button styles to ensure consistency */
.cta-button { display: inline-block; padding: 12px 28px; border: none; border-radius: 50px; font-size: 1rem; font-weight: 600; text-decoration: none; cursor: pointer; transition: all 0.3s ease; color: #ffffff; letter-spacing: 0.5px; }
.cta-button:hover { transform: translateY(-3px); box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1); }
.button-secondary { background-color: #15b371; } /* Green */
.button-secondary:hover { background-color: #7bf2c0; color: #15b371; } /* Light green on hover */

/* Alternate styles */
.cta-button.secondary { background-color: transparent; border: 2px solid; }
.button-secondary-outline { border-color: #15b371; color: #15b371; } /* Green outline */
.button-secondary-outline:hover { background-color: #7bf2c0; color: #15b371; border-color: #7bf2c0;} /* Green outline hover */
</style>