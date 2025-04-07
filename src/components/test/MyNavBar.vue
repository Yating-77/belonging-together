<template>
  <nav class="my-navbar" data-aos="fade-down">
    <div class="navbar-container">
      <div class="navbar-logo">
        <router-link to="/">
          <img src="/Logo.png" alt="Autism Care Logo" class="logo-image">
        </router-link>
      </div>
      <ul class="navbar-links">
        <li><router-link to="/">Home</router-link></li>
        <li><router-link to="/resource">Resource Center</router-link></li>
        <li><router-link to="/recommendation">Personalized Recommendations</router-link></li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { onMounted, onUnmounted } from 'vue';

const handleScroll = () => {
  const navbar = document.querySelector('.my-navbar');
  if (navbar) {
    if (window.scrollY > 50) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  }
};

onMounted(() => { window.addEventListener('scroll', handleScroll); });
onUnmounted(() => { window.removeEventListener('scroll', handleScroll); });
</script>

<style scoped>
.my-navbar {
  position: sticky; top: 0; left: 0; width: 100%;
  background-color: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 0.8rem 5%; z-index: 1000;
  transition: background-color 0.3s ease, box-shadow 0.3s ease, padding 0.3s ease;
}
.my-navbar.scrolled {
  background-color: rgba(255, 255, 255, 0.95); 
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  padding: 0.6rem 5%; backdrop-filter: blur(5px);
}
.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px; margin: 0 auto;
}
.navbar-logo a {
  display: flex;
  align-items: center;
  text-decoration: none;
}
.logo-image {
  height: 40px;
  width: auto;
  display: block;
}
.navbar-links {
  list-style: none;
  display: flex;
  gap: 2rem;
  margin: 0;
  padding: 0;
}
.navbar-links a {
  text-decoration: none;
  color: #6c757d;
  font-weight: 500;
  transition: color 0.3s ease;
}
.navbar-links a:hover, .navbar-links a.active, .navbar-links .router-link-active {
  color: #ffa600;
}
.navbar-cta:hover {
  background-color: #748ffc; 
  color: #ffa600;
  transform: scale(1.05);
}
@media (max-width: 768px) {
  .navbar-links { display: none; }
  .logo-image { height: 35px; }
}
</style>