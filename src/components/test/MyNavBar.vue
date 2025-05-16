<!-- Navigation.vue -->
<template>
  <div>
    <nav class="my-navbar" data-aos="fade-down">
      <div class="navbar-container">
        <div class="navbar-logo">
          <router-link to="/">
            <img src="/Logo.png" alt="Autism Care Logo" class="logo-image">
          </router-link>
        </div>
        
        <div class="mobile-menu-toggle" @click="toggleMobileMenu" :class="{ 'active': mobileMenuOpen }">
          <span></span>
          <span></span>
          <span></span>
        </div>
        
        <ul class="navbar-links">
          <li><router-link to="/insights">Our Insights</router-link></li>
          <li><router-link :to="'/intro'" :class="{ 'router-link-active': isPersonalisedRoute }">Personalised Recommendations</router-link></li>
          <li><router-link to="/venuePage">Community Map</router-link></li>
          <li class="dropdown">
            <a @click.prevent="toggleOutingDropdown" :class="{ 'router-link-active': isOutingSupportActive }">
              Outing Support <span class="arrow">▾</span>
            </a>
            <ul class="nav-dropdown" v-show="outingDropdownOpen">
              <li><router-link to="/detectpage" @click="closeSubmenu">Outing Guides</router-link></li>
              <li><router-link to="/sensoryVenue" @click="closeSubmenu">Sensory Venues</router-link></li>
            </ul>
          </li>
          <li class="dropdown">
            <a @click.prevent="toggleDropdown" :class="{ 'router-link-active': isSupportHubActive }">
              Resource Hub <span class="arrow">▾</span>
            </a>
            <ul class="nav-dropdown" v-show="dropdownOpen">
              <li><router-link to="/skillsGame" @click="closeSubmenu">Skills Game</router-link></li>
              <li><router-link to="/resource" @click="closeSubmenu">Resource Center</router-link></li>
            </ul>
          </li>
        </ul>
      </div>
    </nav>
    
    <!-- spacer -->
    <div :style="{ height: mainSpacerHeight + 'px' }" class="navbar-spacer"></div>
     
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
            <router-link to="/detectpage" @click="closeMobileMenu" :class="{ 'active-tab': route.path === '/detectpage' }">
              Outing Guides
            </router-link>
            <router-link to="/sensoryVenue" @click="closeMobileMenu" :class="{ 'active-tab': route.path === '/sensoryVenue' }">
              Sensory Venues
            </router-link>
          </div>
        </li>
        <li class="mobile-dropdown" :class="{ 'active': mobileDropdownOpen }">
          <a @click.prevent="toggleMobileDropdown" :class="{ 'router-link-active': isSupportHubActive }">
            Resource Hub
          </a>
          <div class="mobile-dropdown-menu" :class="{ 'active': mobileDropdownOpen }">
            <router-link to="/skillsGame" @click="closeMobileMenu" :class="{ 'active-tab': route.path === '/skillsGame' }">
              Skills Game
            </router-link>
            <router-link to="/resource" @click="closeMobileMenu" :class="{ 'active-tab': route.path === '/resource' }">
              Resource Center
            </router-link>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { onMounted, onUnmounted, ref, computed, watch, nextTick } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();
const mobileMenuOpen = ref(false);
const mobileDropdownOpen = ref(false);
const dropdownOpen = ref(false);
const outingDropdownOpen = ref(false);
const mobileOutingDropdownOpen = ref(false);
const submenuContainer = ref(null);

// base height
const NAVBAR_BASE_HEIGHT = 85;
const NAVBAR_MOBILE_HEIGHT = 75;

// main spacer height
const mainSpacerHeight = ref(NAVBAR_BASE_HEIGHT);

const isPersonalisedRoute = computed(() => {
  return route.path === '/intro' || route.path === '/recommendation';
});

const isSupportHubActive = computed(() => {
  return route.path === '/resource' || route.path === '/skillsGame';
});

const isOutingSupportActive = computed(() => {
  return route.path === '/detectpage' || route.path === '/sensoryVenue';
});

// update spacer height
const updateSpacerHeight = () => {
  const isMobile = window.innerWidth <= 992;
  
  if (isMobile) {
    // fixed height on mobile, no spacer when menu is open
    mainSpacerHeight.value = mobileMenuOpen.value ? 0 : NAVBAR_MOBILE_HEIGHT;
  } else {
    // fixed height on desktop
    mainSpacerHeight.value = NAVBAR_BASE_HEIGHT;
  }
};

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value;
  if (mobileMenuOpen.value) {
    document.body.style.overflow = 'hidden';
  } else {
    document.body.style.overflow = '';
  }
  updateSpacerHeight();
};

const toggleMobileDropdown = () => {
  mobileDropdownOpen.value = !mobileDropdownOpen.value;
};

const toggleMobileOutingDropdown = () => {
  mobileOutingDropdownOpen.value = !mobileOutingDropdownOpen.value;
};

const toggleOutingDropdown = (event) => {
  // close other dropdown menus
  if (dropdownOpen.value) {
    dropdownOpen.value = false;
  }
  
  outingDropdownOpen.value = !outingDropdownOpen.value;
  
  // prevent event bubbling
  if (event) {
    event.stopPropagation();
  }
};

const toggleDropdown = (event) => {
  // close other dropdown menus
  if (outingDropdownOpen.value) {
    outingDropdownOpen.value = false;
  }
  
  dropdownOpen.value = !dropdownOpen.value;
  
  // prevent event bubbling
  if (event) {
    event.stopPropagation();
  }
};

const closeMobileMenu = () => {
  mobileMenuOpen.value = false;
  mobileDropdownOpen.value = false;
  mobileOutingDropdownOpen.value = false;
  document.body.style.overflow = '';
  updateSpacerHeight();
};

// close submenu
const closeSubmenu = () => {
  // immediately close
  dropdownOpen.value = false;
  outingDropdownOpen.value = false;
};

// when route changes, close all dropdown menus
watch(route, () => {
  // set dropdown menu state to close
  dropdownOpen.value = false;
  outingDropdownOpen.value = false;
  closeMobileMenu();
  
  // use nextTick to ensure DOM update
  nextTick(() => {
    updateSpacerHeight();
  });
});

const handleClickOutside = (event) => {
  // click anywhere on the page to close dropdown menus
  dropdownOpen.value = false;
  outingDropdownOpen.value = false;
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

// listen window size change
const handleResize = () => {
  const isMobile = window.innerWidth <= 992;
  
  // auto close submenu on mobile
  if (isMobile) {
    if (outingDropdownOpen.value || dropdownOpen.value) {
      outingDropdownOpen.value = false;
      dropdownOpen.value = false;
    }
  }
  
  // update height
  updateSpacerHeight();
};

onMounted(() => { 
  window.addEventListener('scroll', handleScroll);
  window.addEventListener('resize', handleResize);
  document.addEventListener('click', handleClickOutside);
  
  // initialize height
  updateSpacerHeight();
});

onUnmounted(() => { 
  window.removeEventListener('scroll', handleScroll);
  window.removeEventListener('resize', handleResize);
  document.removeEventListener('click', handleClickOutside);
  document.body.style.overflow = '';
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

.navbar-spacer {
  transition: height 0.3s ease;
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

/* Arrow for dropdown */
.arrow {
  font-size: 0.8em;
  margin-left: 4px;
}

/* Dropdown menu style */
.dropdown {
  position: relative;
}

.dropdown > a {
  cursor: pointer;
}

/* 垂直下拉菜单样式 */
.nav-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  min-width: 220px;
  background: #fff;
  box-shadow: 0 3px 12px rgba(0, 0, 0, 0.15);
  border-radius: 4px;
  overflow: hidden;
  z-index: 1000;
  padding: 8px 0;
  margin-top: 8px;
}

.nav-dropdown li {
  display: block;
  width: 100%;
}

.nav-dropdown li a {
  padding: 10px 20px;
  color: #6c757d;
  font-weight: 500;
  font-size: 0.95rem;
  display: block;
  transition: all 0.2s ease;
}

.nav-dropdown li a:hover {
  background-color: rgba(62, 92, 43, 0.1);
  color: #3E5C2B;
}

.nav-dropdown li a:after {
  display: none;
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
  padding: 12px 25px !important;
  font-size: 1rem;
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

.mobile-dropdown-menu a.active-tab {
  background-color: rgba(62, 92, 43, 0.1);
  color: #3E5C2B;
  font-weight: 600;
  border-left: 4px solid #3E5C2B;
  padding-left: 21px !important;
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