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
        <li><router-link to="/insights">Our Insights</router-link></li>
        <li><router-link :to="'/intro'" :class="{ 'router-link-active': isPersonalisedRoute }">Personalised Recommendations</router-link></li>
        <li><router-link to="/venuePage">Community Map</router-link></li>
        <li class="dropdown" @mouseenter="showOutingDropdown" @mouseleave="hideOutingDropdownWithDelay">
          <a @click="toggleOutingDropdown($event)" :class="{ 'router-link-active': isOutingSupportActive }" class="dropdown-link">
            Outing Support
          </a>
          <ul class="dropdown-menu" :class="{ 'active': outingDropdownOpen }" @mouseenter="showOutingDropdown" @mouseleave="hideOutingDropdownWithDelay">
            <li>
              <router-link to="/detectpage" class="dropdown-item" @click="outingDropdownOpen = false">
                Outing Guides
              </router-link>
            </li>
            <li>
              <router-link to="/sensoryVenue" class="dropdown-item" @click="outingDropdownOpen = false">
                Sensory Venues
              </router-link>
            </li>
          </ul>
        </li>
        <li class="dropdown" @mouseenter="showSupportDropdown" @mouseleave="hideSupportDropdownWithDelay">
          <a @click="toggleDropdown($event)" :class="{ 'router-link-active': isSupportHubActive }" class="dropdown-link">
            Resource Hub
          </a>
          <ul class="dropdown-menu" :class="{ 'active': dropdownOpen }" @mouseenter="showSupportDropdown" @mouseleave="hideSupportDropdownWithDelay">
            <li>
              <router-link to="/skillsGame" class="dropdown-item" @click="dropdownOpen = false">
                Skills Game
              </router-link>
            </li>
            <li>
              <router-link to="/resource" class="dropdown-item" @click="dropdownOpen = false">
                Resource Center
              </router-link>
            </li>
          </ul>
        </li>
      </ul>
    </div>
    
   
    <div class="mobile-menu" :class="{ 'active': mobileMenuOpen }">
      <ul class="mobile-links">
        <li><router-link to="/insights" @click="closeMobileMenu">Our Insights</router-link></li>
        <li><router-link :to="'/intro'" :class="{ 'router-link-active': isPersonalisedRoute }" @click="closeMobileMenu">Personalised Recommendations</router-link></li>
        <li><router-link to="/venuePage" @click="closeMobileMenu">Community Map</router-link></li>
        <li class="mobile-dropdown" :class="{ 'active': mobileOutingDropdownOpen }">
          <a @click.prevent="toggleMobileOutingDropdown" :class="{ 'router-link-active': isOutingSupportActive }">
            Outing Support
          </a>
          <div class="mobile-dropdown-menu" :class="{ 'active': mobileOutingDropdownOpen }">
            <router-link to="/detectpage" @click="closeMobileMenu">
              Outing Guides
            </router-link>
            <router-link to="/sensoryVenue" @click="closeMobileMenu">
              Sensory Venues
            </router-link>
          </div>
        </li>
        <li class="mobile-dropdown" :class="{ 'active': mobileDropdownOpen }">
          <a @click.prevent="toggleMobileDropdown" :class="{ 'router-link-active': isSupportHubActive }">
            Resource Hub
          </a>
          <div class="mobile-dropdown-menu" :class="{ 'active': mobileDropdownOpen }">
            <router-link to="/skillsGame" @click="closeMobileMenu">
              Skills Game
            </router-link>
            <router-link to="/resource" @click="closeMobileMenu">
              Resource Center
            </router-link>
          </div>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script setup>
import { onMounted, onUnmounted, ref, computed, watch } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const mobileMenuOpen = ref(false);
const mobileDropdownOpen = ref(false);
const dropdownOpen = ref(false);
const outingDropdownOpen = ref(false);
const mobileOutingDropdownOpen = ref(false);
const outingDropdownTimer = ref(null);
const supportDropdownTimer = ref(null);

const isPersonalisedRoute = computed(() => {
  return route.path === '/intro' || route.path === '/recommendation';
});

const isSupportHubActive = computed(() => {
  return route.path === '/resource' || route.path === '/skillsGame';
});

const isOutingSupportActive = computed(() => {
  return route.path === '/detectpage' || route.path === '/sensoryVenue';
});

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value;
  if (mobileMenuOpen.value) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
};

const toggleMobileDropdown = () => {
  mobileDropdownOpen.value = !mobileDropdownOpen.value;
};

const toggleMobileOutingDropdown = () => {
  mobileOutingDropdownOpen.value = !mobileOutingDropdownOpen.value;
};

const toggleOutingDropdown = (event) => {
  event.stopPropagation();
  outingDropdownOpen.value = !outingDropdownOpen.value;
  if (outingDropdownOpen.value) {
    dropdownOpen.value = false;
    // make the dropdown menu items visible
    setTimeout(() => {
      const menuItems = document.querySelectorAll('.navbar-links > li:nth-child(3) .dropdown-menu li');
      menuItems.forEach((item, index) => {
        item.style.opacity = '1';
        item.style.visibility = 'visible';
        item.style.transform = 'translateY(0)';
        item.style.transitionDelay = `${0.05 * (index + 1)}s`;
      });
    }, 10);
  }
};

const toggleDropdown = (event) => {
  event.stopPropagation();
  dropdownOpen.value = !dropdownOpen.value;
  if (dropdownOpen.value) {
    outingDropdownOpen.value = false;
    // make the dropdown menu items visible
    setTimeout(() => {
      const menuItems = document.querySelectorAll('.navbar-links > li:nth-child(4) .dropdown-menu li');
      menuItems.forEach((item, index) => {
        item.style.opacity = '1';
        item.style.visibility = 'visible';
        item.style.transform = 'translateY(0)';
        item.style.transitionDelay = `${0.05 * (index + 1)}s`;
      });
    }, 10);
  }
};

// show the Outing Support dropdown menu
const showOutingDropdown = () => {
  clearTimeout(outingDropdownTimer.value);
  outingDropdownOpen.value = true;
  dropdownOpen.value = false;
  
  // make the dropdown menu items visible
  setTimeout(() => {
    const menuItems = document.querySelectorAll('.navbar-links > li:nth-child(3) .dropdown-menu li');
    menuItems.forEach((item, index) => {
      item.style.opacity = '1';
      item.style.visibility = 'visible';
      item.style.transform = 'translateY(0)';
      item.style.transitionDelay = `${0.05 * (index + 1)}s`;
    });
  }, 10);
};

// delay hide the Outing Support dropdown menu
const hideOutingDropdownWithDelay = () => {
  outingDropdownTimer.value = setTimeout(() => {
    outingDropdownOpen.value = false;
  }, 300);
};

// show the Support Hub dropdown menu
const showSupportDropdown = () => {
  clearTimeout(supportDropdownTimer.value);
  dropdownOpen.value = true;
  outingDropdownOpen.value = false;
  
  // make the dropdown menu items visible
  setTimeout(() => {
    const menuItems = document.querySelectorAll('.navbar-links > li:nth-child(4) .dropdown-menu li');
    menuItems.forEach((item, index) => {
      item.style.opacity = '1';
      item.style.visibility = 'visible';
      item.style.transform = 'translateY(0)';
      item.style.transitionDelay = `${0.05 * (index + 1)}s`;
    });
  }, 10);
};

// delay hide the Support Hub dropdown menu
const hideSupportDropdownWithDelay = () => {
  supportDropdownTimer.value = setTimeout(() => {
    dropdownOpen.value = false;
  }, 300);
};

const closeMobileMenu = () => {
  mobileMenuOpen.value = false;
  mobileDropdownOpen.value = false;
  mobileOutingDropdownOpen.value = false;
  document.body.style.overflow = '';
};

// when the page route changes, close the dropdown menu
watch(route, () => {
  dropdownOpen.value = false;
  outingDropdownOpen.value = false;
});

// when the page route changes, close the dropdown menu
const handleClickOutside = (event) => {
  const supportDropdown = document.querySelector('.dropdown:nth-child(4)');
  const outingDropdown = document.querySelector('.dropdown:nth-child(3)');
  
  if (supportDropdown && !supportDropdown.contains(event.target) && dropdownOpen.value) {
    dropdownOpen.value = false;
  }
  
  if (outingDropdown && !outingDropdown.contains(event.target) && outingDropdownOpen.value) {
    outingDropdownOpen.value = false;
  }
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
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => { 
  window.removeEventListener('scroll', handleScroll);
  document.removeEventListener('click', handleClickOutside);
  document.body.style.overflow = ''; 
  clearTimeout(outingDropdownTimer.value);
  clearTimeout(supportDropdownTimer.value);
});
</script>
<style scoped>
.my-navbar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  padding: 0.5rem 3%;
  z-index: 1050;
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
  position: relative;
  overflow: visible !important;
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
  position: relative;
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

/* dropdown menu style */
.dropdown {
  position: relative;
  display: inline-block;
  z-index: 1050;
}

.dropdown > a {
  cursor: pointer;
}

.dropdown-link {
  display: block;
  padding: 0.7rem 0.3rem;
}

/* basic dropdown menu style */
.dropdown-menu {
  position: absolute;
  top: 100%;
  left: -20px;
  background-color: white;
  box-shadow: 0 10px 25px rgba(0,0,0,0.12);
  border-radius: 14px;
  padding: 16px 0;
  min-width: 260px;
  list-style: none;
  opacity: 0;
  visibility: hidden;
  transform: translateY(10px);
  transition: all 0.25s cubic-bezier(0.3, 0, 0.3, 1);
  z-index: 1100;
  margin-top: 10px;
  border: 1px solid rgba(0,0,0,0.05);
  overflow: visible;
  backdrop-filter: blur(10px);
  pointer-events: none;
}

.dropdown-menu:before {
  content: '';
  position: absolute;
  top: -6px;
  left: 40px;
  width: 12px;
  height: 12px;
  background-color: white;
  transform: rotate(45deg);
  border-top: 1px solid rgba(0,0,0,0.05);
  border-left: 1px solid rgba(0,0,0,0.05);
  z-index: -1;
}

.dropdown-menu.active,
.dropdown:hover .dropdown-menu {
  opacity: 1 !important;
  visibility: visible !important;
  display: block !important;
  pointer-events: auto !important;
  z-index: 9999 !important;
}

.dropdown-menu li {
  opacity: 0;
  transform: translateY(5px);
  transition: all 0.3s ease;
  transition-delay: 0s;
  margin: 8px 0;
  list-style: none;
  visibility: hidden;
}

.dropdown-menu.active li,
.dropdown:hover .dropdown-menu li {
  opacity: 1 !important;
  visibility: visible !important;
  transform: translateY(0) !important;
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.dropdown-menu.active li:nth-child(1) {
  transition-delay: 0.05s;
}

.dropdown-menu.active li:nth-child(2) {
  transition-delay: 0.1s;
}

.dropdown-item {
  display: flex;
  align-items: center;
  padding: 16px 30px;
  text-decoration: none;
  color: #5a6268;
  font-size: 1rem;
  transition: all 0.2s ease;
  white-space: nowrap;
  width: 100%;
  position: relative;
  font-weight: 500;
  border-radius: 8px;
  margin: 0 10px;
  width: calc(100% - 20px);
  text-align: left;
  overflow: visible;
}

.dropdown-item:hover {
  background-color: rgba(62, 92, 43, 0.08);
  color: #3E5C2B;
  padding-left: 34px;
}

.dropdown-item:active {
  background-color: rgba(62, 92, 43, 0.12);
  transform: scale(0.98);
}

.navbar-links > li:nth-child(3) .dropdown-menu {
  left: 50%;
  transform: translateX(-50%) translateY(10px);
}

.navbar-links > li:nth-child(3) .dropdown-menu.active {
  transform: translateX(-50%) translateY(0);
}

.navbar-links > li:nth-child(3) .dropdown-menu:before {
  left: 50%;
  transform: translateX(-50%) rotate(45deg);
}

.navbar-links > li:nth-child(4) .dropdown-menu {
  right: 0 !important;
  left: auto !important;
  transform: translateY(10px) !important;
  width: 280px !important;
  max-width: 280px !important;
}

.navbar-links > li:nth-child(4) .dropdown-menu:before {
  left: auto;
  right: 25px;
}

@media (hover: hover) {
  .dropdown:hover .dropdown-menu {
    opacity: 1;
    visibility: visible;
    display: block;
    pointer-events: auto;
    z-index: 1100;
  }

  .navbar-links > li:nth-child(3):hover .dropdown-menu {
    transform: translateX(-50%) translateY(0);
  }

  .navbar-links > li:nth-child(4):hover .dropdown-menu {
    transform: translateY(0);
  }
}

.mobile-dropdown {
  position: relative;
}

.mobile-dropdown > a {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
}

.mobile-dropdown-menu {
  max-height: 0;
  overflow: hidden;
  background-color: rgba(240, 248, 234, 0.3);
  border-radius: 12px;
  margin: 0;
  transition: all 0.3s ease;
}

.mobile-dropdown-menu.active {
  max-height: 200px;
  padding: 12px 0;
  margin: 10px 0;
  box-shadow: inset 0 0 10px rgba(0,0,0,0.03);
}

.mobile-dropdown-menu a {
  padding: 18px 28px !important;
  font-size: 1.05rem;
  display: flex;
  align-items: center;
  text-decoration: none;
  color: #6c757d;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
  margin: 0 6px;
  border-radius: 8px;
}

.mobile-dropdown-menu a:hover {
  background-color: rgba(62, 92, 43, 0.05);
}

.mobile-dropdown-menu a:last-child {
  border-bottom: none;
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
  
  .dropdown-menu {
    max-width: calc(100vw - 40px);
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