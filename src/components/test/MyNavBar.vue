<template>
  <nav class="my-navbar" data-aos="fade-down">
    <div class="navbar-container">
      <div class="navbar-logo">
        <router-link to="/">
          <img src="/Logo.png" alt="Autism Care Logo" class="logo-image">
        </router-link>
      </div>
      
    
      <div class="mobile-menu-toggle" @click="toggleMobileMenu">
        <span></span>
        <span></span>
        <span></span>
      </div>
      
      <ul class="navbar-links">
        <li><router-link to="/">Home</router-link></li>
        <li><router-link to="/resource">Resource Center</router-link></li>
        <li><router-link to="/recommendation">Personalized Recommendations</router-link></li>
      </ul>
    </div>
    
   
    <div class="mobile-menu" :class="{ 'active': mobileMenuOpen }">
      <ul class="mobile-links">
        <li><router-link to="/" @click="closeMobileMenu">Home</router-link></li>
        <li><router-link to="/resource" @click="closeMobileMenu">Resource Center</router-link></li>
        <li><router-link to="/recommendation" @click="closeMobileMenu">Personalized Recommendations</router-link></li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { onMounted, onUnmounted, ref } from 'vue';

const mobileMenuOpen = ref(false);

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value;

  if (mobileMenuOpen.value) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
};

const closeMobileMenu = () => {
  mobileMenuOpen.value = false;
  document.body.style.overflow = '';
};

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

onMounted(() => { 
  window.addEventListener('scroll', handleScroll);
});

onUnmounted(() => { 
  window.removeEventListener('scroll', handleScroll);
  document.body.style.overflow = ''; 
});
</script>

<style scoped>
.my-navbar {
  position: sticky;
  top: 0;
  left: 0;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  padding: 0.8rem 5%;
  z-index: 1000;
  transition: background-color 0.3s ease, box-shadow 0.3s ease, padding 0.3s ease;
}

.my-navbar.scrolled {
  background-color: rgba(255, 255, 255, 0.95);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  padding: 0.6rem 5%;
  backdrop-filter: blur(5px);
}

.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1200px;
  margin: 0 auto;
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
  padding: 0.5rem 0;
  display: block;
  transition: color 0.3s ease;
}

.navbar-links a:hover,
.navbar-links a.active,
.navbar-links .router-link-active {
  color: #3E5C2B;
}

.mobile-menu-toggle {
  display: none;
  flex-direction: column;
  justify-content: space-between;
  width: 30px;
  height: 21px;
  cursor: pointer;
  z-index: 1010;
}

.mobile-menu-toggle span {
  display: block;
  height: 3px;
  width: 100%;
  background-color: #6c757d;
  border-radius: 3px;
  transition: all 0.3s ease;
}

.mobile-menu {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  background-color: white;
  z-index: 1000;
  padding-top: 5rem;
  transform: translateX(-100%);
  transition: transform 0.3s ease;
  overflow-y: auto;
}

.mobile-menu.active {
  transform: translateX(0);
}

.mobile-links {
  list-style: none;
  padding: 0 2rem;
  margin: 0;
}

.mobile-links li {
  margin-bottom: 0;
  border-bottom: 1px solid #f0f0f0;
}

.mobile-links a {
  color: #6c757d;
  text-decoration: none;
  font-size: 1.1rem;
  font-weight: 500;
  padding: 1rem 0;
  display: block;
  transition: color 0.3s ease;
}

.mobile-links a:hover,
.mobile-links a.active,
.mobile-links .router-link-active {
  color: #3E5C2B;
}

@media (max-width: 768px) {
  .navbar-links {
    display: none;
  }
  
  .mobile-menu-toggle {
    display: flex;
  }
  
  .logo-image {
    height: 35px;
  }
}

.mobile-menu-toggle.active span:nth-child(1) {
  transform: translateY(9px) rotate(45deg);
}

.mobile-menu-toggle.active span:nth-child(2) {
  opacity: 0;
}

.mobile-menu-toggle.active span:nth-child(3) {
  transform: translateY(-9px) rotate(-45deg);
}

@media (max-width: 320px) {
  .my-navbar {
    padding: 0.7rem 4%;
  }
  
  .logo-image {
    height: 30px;
  }
  
  .mobile-links a {
    padding: 1.2rem 0;
    font-size: 1.2rem;
  }
}
</style>