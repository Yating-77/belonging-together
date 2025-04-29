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
        <li><router-link to="/intro">Personalised Recommendations</router-link></li>
        <li><router-link to="/detectpage">Outing Guides</router-link></li>
        <li><router-link to="/sensoryVenue">Sensory Venues</router-link></li>
      </ul>
    </div>
    
   
    <div class="mobile-menu" :class="{ 'active': mobileMenuOpen }">
      <ul class="mobile-links">
        <li><router-link to="/" @click="closeMobileMenu">Home</router-link></li>
        <li><router-link to="/resource" @click="closeMobileMenu">Resource Center</router-link></li>
        <li><router-link to="/intro" @click="closeMobileMenu">Personalised Recommendations</router-link></li>
        <li><router-link to="/detectpage" @click="closeMobileMenu">Outing Guides</router-link></li>
        <li><router-link to="/sensoryVenue" @click="closeMobileMenu">Sensory Venues</router-link></li>
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
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  padding: 0.5rem 3%;
  z-index: 1000;
  transition: all 0.3s ease;
}

.my-navbar.scrolled {
  background-color: rgba(255, 255, 255, 0.95);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
  padding: 0.3rem 3%;
  backdrop-filter: blur(5px);
}

.navbar-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  padding: 0;
}

.navbar-logo {
  margin-left: 0;
}

.navbar-logo a {
  display: flex;
  align-items: center;
  text-decoration: none;
}

.logo-image {
  height: 65px;
  width: auto;
  display: block;
  transition: height 0.3s ease;
}

.navbar-links {
  list-style: none;
  display: flex;
  gap: 2.2rem;
  margin: 0;
  padding: 0;
  margin-right: 0;
}

.navbar-links a {
  text-decoration: none;
  color: #6c757d;
  font-weight: 600;
  font-size: 1.05rem;
  padding: 0.7rem 0.3rem;
  display: block;
  transition: all 0.3s ease;
  position: relative;
}

.navbar-links a:after {
  content: '';
  position: absolute;
  width: 0;
  height: 2px;
  background: #3E5C2B;
  bottom: 0;
  left: 0;
  transition: width 0.3s ease;
}

.navbar-links a:hover:after,
.navbar-links a.router-link-active:after {
  width: 100%;
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
  width: 28px;
  height: 20px;
  cursor: pointer;
  z-index: 1010;
  margin-right: 0;
}

.mobile-menu-toggle span {
  display: block;
  height: 3px;
  width: 100%;
  background-color: #3E5C2B;
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
  padding-top: 6rem;
  transform: translateX(-100%);
  transition: all 0.4s ease;
  overflow-y: auto;
  box-shadow: 5px 0 15px rgba(0, 0, 0, 0.1);
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
  font-size: 1.15rem;
  font-weight: 500;
  padding: 1.3rem 0;
  display: block;
  transition: all 0.3s ease;
}

.mobile-links a:hover,
.mobile-links a.active,
.mobile-links .router-link-active {
  color: #3E5C2B;
  padding-left: 0.5rem;
}

@media (max-width: 1200px) {
  .navbar-links {
    gap: 1.5rem;
  }
  
  .navbar-links a {
    font-size: 1rem;
  }
  
  .logo-image {
    height: 60px;
  }
}

@media (max-width: 992px) {
  .navbar-links {
    display: none;
  }
  
  .mobile-menu-toggle {
    display: flex;
  }
  
  .logo-image {
    height: 55px;
  }
  
  .mobile-menu-toggle span {
    height: 3px;
    margin-bottom: 0;
    width: 28px;
  }
  
  .my-navbar {
    padding: 0.8rem 5%;
  }
  
  .navbar-container {
    padding: 0;
  }
}

@media (max-width: 768px) {
  .logo-image {
    height: 50px;
  }
}

.mobile-menu-toggle.active span:nth-child(1) {
  transform: translateY(8px) rotate(45deg);
}

.mobile-menu-toggle.active span:nth-child(2) {
  opacity: 0;
}

.mobile-menu-toggle.active span:nth-child(3) {
  transform: translateY(-8px) rotate(-45deg);
}

@media (max-width: 576px) {
  .my-navbar {
    padding: 0.7rem 5%;
  }
  
  .logo-image {
    height: 45px;
  }
  
  .mobile-links a {
    padding: 1.2rem 0;
    font-size: 1.1rem;
  }
}

@media (max-width: 375px) {
  .my-navbar {
    padding: 0.7rem 4%;
  }
  
  .logo-image {
    height: 40px;
  }
  
  .mobile-links a {
    padding: 1.1rem 0;
    font-size: 1.05rem;
  }
}
</style>