<template>
<section class="video-promo-section" aria-labelledby="video-promo-heading">
  <div class="video-promo-container">
    <div class="video-box-with-source">
      <div class="video-box">
        <iframe
          width="100%"
          height="100%"
          src="https://www.youtube.com/embed/0idZghw97dc"
          title="Autism Speaks PSA"
          frameborder="0"
          allowfullscreen
        ></iframe>
      </div>
      <p class="video-source">
        Source: <a href="https://www.youtube.com/watch?v=0idZghw97dc" target="_blank" rel="noopener">Autism Speaks</a>
      </p>
    </div>
    <div class="promo-text-box">
      <h2 class="section-title">Does this sound familiar?</h2>
      <p class="promo-subtitle">
        <p>Every child has a world inside, full of thoughts, feelings, and ways of seeing the world that may not always be easy to express.</p>
        
        <p>As a parent, you might sometimes wonder: "Why does my child react this way?" or "Am I doing the right thing?"</p>
        
        <p>We're here to support you on that journey. Through warm, situation-based tools grounded in real-life parenting challenges, we help you better understand your child's unique needs, and build more confident, connected, and compassionate moments together.</p>
      </p>
      <router-link to="/recommendation" class="cta-button button-secondary">Get Personalised Recommendations</router-link>
    </div>
  </div>
</section>

  </template>
  
  <style scoped>

  .split-hero-section {
    display: flex;
    min-height: 80vh;
    background-color: #ffffff;
    overflow: hidden;
  }
  
  .hero-video-content {
    flex: 1 1 55%;
    padding: 3rem 4% 3rem 5%;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .hero-video-content iframe {
    width: 100%;
    height: 100%;
    aspect-ratio: 16 / 9;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
  }
  
  .hero-text-content {
    flex: 1 1 45%;
    padding: 3rem 5% 3rem 3%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
  }

  
  .hero-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
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
  
  .button-secondary {
    background-color: #3E5C2B;
  }
  
  .button-secondary:hover {
    background-color: #4d7234;
    color: #ffffff;
  }
  
  @media (max-width: 992px) {
    .split-hero-section {
      flex-direction: column;
      min-height: auto;
    }
  
    .hero-video-content,
    .hero-text-content {
      flex-basis: auto;
      padding: 2rem 5%;
      text-align: center;
      align-items: center;
    }
  
    .hero-title {
      font-size: clamp(2.2rem, 7vw, 3rem);
    }
  
    .hero-subtitle {
      font-size: clamp(1rem, 3vw, 1.1rem);
      margin-left: auto;
      margin-right: auto;
    }
  
    .hero-actions {
      justify-content: center;
      margin-bottom: 2rem;
    }
  
    .hero-video-content iframe {
      width: 100%;
      height: auto;
      aspect-ratio: 16 / 9;
    }
  }
  .video-promo-section {
  padding: 5rem 5%;
  background-color: #ffffff;
}

.video-promo-container {
  display: flex;
  flex-wrap: wrap;
  gap: 4rem;
  align-items: center;
  justify-content: space-between;
  max-width: 1400px;
  margin: 0 auto;
}

.video-source {
  color: #4d7234;
  margin-top: 0.75rem;
}
.video-source a {
  color: #4d7234;
  text-decoration: underline;
  font-weight: 500;
}

.video-box-with-source {
  flex: 1 1 60%;
  min-width: 600px;
}
.video-box {
  aspect-ratio: 16 / 9;
  background-color: #eee;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.promo-text-box {
  flex: 1 1 35%;
  min-width: 280px;
  text-align: left;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  height: 100%;
  min-height: 400px;
  padding: 0;
}

.promo-text-box h2 {
  font-size: clamp(2rem, 4vw, 2.5rem);
  font-weight: 700;
  color: #4d2f20;
  margin: 0 0 2.5rem 0;
}

.promo-subtitle {
  font-size: clamp(1rem, 2vw, 1.1rem);
  color: #6c757d;
  line-height: 1.8;
  margin: 0;
}

.promo-subtitle p {
  margin: 0 0 1.5rem 0;
}

.promo-subtitle p:last-child {
  margin-bottom: 0;
}

.cta-button {
  align-self: flex-start;
  margin-top: 3rem;
}

@media (max-width: 1200px) {
  .video-box-with-source {
    min-width: 500px;
  }
}

@media (max-width: 768px) {
  .video-promo-container {
    gap: 2rem;
  }
  
  .video-box-with-source {
    min-width: 100%;
  }

  .promo-text-box {
    text-align: center;
    align-items: center;
    min-height: 350px;
  }
}
.button-secondary { background-color: #3E5C2B; } 
.button-secondary:hover { background-color: #4d7234; color: #ffffff; } 

.cta-button.secondary { background-color: transparent; border: 2px solid; }
.button-secondary-outline { border-color: #3E5C2B; color: #3E5C2B; } 
.button-secondary-outline:hover { background-color: #3E5C2B; color: #ffffff; border-color: #3E5C2B;} 
  </style>
  