<template>
  <footer class="my-footer">
    <div class="footer-container">
      <div class="footer-section about">
        <img src="/whiteLogo.png" alt="Belonging Together Logo" class="footer-logo" />
        <h4>About Us</h4>
        <p>Dedicated to providing professional and friendly information and support for Autism Spectrum Disorder.</p>
      </div>
      <div class="footer-section links">
        <h4>Quick Links</h4>
        <div class="links-columns">
          <div class="links-column">
            <ul>
              <li><router-link to="/">Home</router-link></li>
              <li><router-link to="/insights">Our Insights</router-link></li>
              <li><router-link to="/venuePage">Community Map</router-link></li>
              <li><router-link to="/intro">Personalised Recommendations</router-link></li>
            </ul>
          </div>
          <div class="links-column">
            <ul>
              <li class="footer-dropdown">
                <span class="footer-dropdown-title">Outing Support</span>
                <ul class="footer-submenu">
                  <li><router-link to="/detectpage">Outing Guides</router-link></li>
                  <li><router-link to="/sensoryVenue">Sensory Venues</router-link></li>
                </ul>
              </li>
            </ul>
          </div>
          <div class="links-column">
            <ul>
              <li class="footer-dropdown">
                <span class="footer-dropdown-title">Resource Hub</span>
                <ul class="footer-submenu">
                  <li><router-link to="/skillsGame">Skills Game</router-link></li>
                  <li><router-link to="/resource">Resource Center</router-link></li>
                </ul>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <p>© {{ new Date().getFullYear() }} Belonging Together. All Rights Reserved.</p>
    </div>
  </footer>
</template>

<script setup>
</script>

<style scoped>
.my-footer {
  background-color: #343a40; 
  color: #adb5bd; 
  padding: 6rem 5% 1rem;
  margin-bottom: 0;
  width: 100%;
}

.footer-logo {
  max-width: 150px;
  margin-bottom: 1.2rem;
  display: block;
}

.footer-container {
  display: grid; 
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem; 
  max-width: 1100px; 
  margin: 0 auto 3rem;
}
.footer-section h4 {
  color: #ffffff; 
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
}
.footer-section p {
  font-size: 0.9rem;
  line-height: 1.6;
  margin-bottom: 0.5rem;
  color: #adb5bd;
  max-width: none;
}

.links-columns {
  display: flex;
  gap: 2rem;
}

.links-column {
  flex: 1;
}

.footer-section ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.footer-section li {
  margin-bottom: 1rem;
}
.footer-section a {
  color: #adb5bd;
  text-decoration: none;
  transition: color 0.3s ease;
}
.footer-section a:hover, .footer-section .router-link-active {
  color: #ffffff; 
  text-decoration: underline;
}

.footer-dropdown {
  margin-bottom: 1.2rem;
}

.footer-dropdown-title {
  color: #ffffff;
  font-weight: 500;
  display: block;
  margin-bottom: 0.6rem;
}

.footer-submenu {
  padding-left: 0 !important;
}

.footer-submenu li {
  margin-bottom: 0.6rem;
}

.footer-bottom {
  text-align: center;
  border-top: 1px solid #495057; 
  padding-top: 2rem;
  margin-top: 2rem;
}
.footer-bottom p {
  font-size: 0.85rem;
  color: #6c757d; 
  margin-bottom: 0;
  padding-bottom: 0;
}

@media (max-width: 992px) {
  .links-columns {
    flex-direction: column;
    gap: 1rem;
  }
  
  .footer-container {
    grid-template-columns: 1fr;
  }
}
</style>