<template>
  <div class="venue-finder-page container-fluid px-0">
    <MyNavBar />

    <!-- Intro Section with proper styling -->
    <div class="hero-banner">
      <div class="hero-image-container">
        <img src="/sensory-venue.png" alt="Finding sensory friendly venues" class="hero-image" />
      </div>
      <div class="hero-text-overlay">
        <div class="container text-center">
          <h1 class="main-title">Find Sensory-Friendly Venues</h1>
          <p class="main-subtitle">
            Discover locations in Victoria offering sensory accommodations like quiet hours, trained staff, and more.
          </p>
        </div>
      </div>
    </div>

    <!-- Filter Section -->
    <div class="search-container">
      <div class="container">
        <div class="filter-section py-4">
          <!-- Main Search Row -->
          <div class="row g-3 justify-content-center">
            <!-- Search Bar with Button -->
            <div class="col-lg-12 col-md-12">
              <div class="search-box-container">
                <div class="input-group search-input-group">
                  <span class="input-group-text search-icon">
                    <i class="fas fa-search"></i>
                  </span>
                  <input
                    type="text"
                    class="form-control search-input"
                    placeholder="Search by name or keyword..."
                    v-model="searchQuery"
                    @keyup.enter="applyFilters"
                  />
                  <button v-if="searchQuery" 
                    class="input-group-text clear-input-btn" 
                    @click="clearSearchQuery">
                    <i class="fas fa-times"></i>
                  </button>
                  <button class="btn btn-search" @click="applyFilters">
                    Search
                  </button>
                </div>
                
                <!-- Search Tips -->
                
              </div>
            </div>
          </div>
          
          <!-- Sensory Features Filter -->
          <div class="row mt-4 justify-content-center">
            <div class="col-lg-12 col-md-12">
              <div class="filter-card">
                <div class="filter-label mb-2">
                  <i class="fas fa-filter me-2"></i> Filter by Sensory Features:
                </div>
                <div class="filter-chips-container">
                  <button 
                    class="filter-chip" 
                    :class="{ 'active': selectedSensoryCategory === null }"
                    @click="selectSensoryFeature(null)">
                    All Features
                  </button>
                  <button 
                    v-for="cat in sensoryCategories" 
                    :key="cat" 
                    class="filter-chip"
                    :class="{ 'active': selectedSensoryCategory === cat }"
                    @click="selectSensoryFeature(cat)">
                    {{ cat }}
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Results Section with consistent styling -->
    <div class="results-section container mb-5">
      <!-- search result header -->
      <div v-if="isFiltered" class="search-result-header mb-4">
        <div class="d-flex justify-content-between align-items-center">
          <h2 class="search-results-title">
            <i class="fas fa-clipboard-list me-2"></i>Search Results
          </h2>
          <button class="clear-search-btn" @click="clearAllFilters">
            <i class="fas fa-undo me-1"></i> Clear Search
          </button>
        </div>
        <p class="search-summary mb-0">
          <span v-if="searchQuery">Keyword: <strong>{{ searchQuery }}</strong></span>
          <span v-if="selectedSensoryCategory"> | Sensory Feature: <strong>{{ selectedSensoryCategory }}</strong></span>
        </p>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary-custom" role="status">
          <span class="visually-hidden">Loading venues...</span>
        </div>
        <p class="loading-text mt-2">Loading venues...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="alert alert-danger error-box mx-auto" style="max-width: 700px;">
        <strong>Error:</strong> {{ error }}
        <p class="mb-0 mt-1"><small>Unable to load venues. Please check your connection or filters and try again.</small></p>
      </div>

      <!-- No Results State -->
      <div v-else-if="venues.length === 0" class="text-center py-5 no-results">
        <i class="fas fa-map-marker-alt fa-3x mb-3"></i>
        <h4>No Venues Found</h4>
        <p>Please try adjusting your search terms or filters.</p>
        <button class="clear-search-btn mt-3" @click="clearAllFilters">
          <i class="fas fa-undo me-1"></i> View All Venues
        </button>
      </div>

      <!-- Venues Grid with Info Cards - use two-column layout -->
      <div v-else class="row g-4">
        <!-- venue card area - occupies left 8 columns -->
        <div class="col-lg-8">
          <div class="row g-4">
            <div v-for="venue in venues" :key="venue.id" class="col-md-6">
              <div class="card venue-card h-100" data-aos="fade-up">
                <img 
                  :src="getImageUrl(venue)" 
                  class="card-img-top venue-image" 
                  :alt="venue.venue_title + ' image'"
                  @error="handleImageError($event)"
                >
                <div class="card-body d-flex flex-column">
                  <h5 class="card-title venue-title">{{ venue.venue_title }}</h5>
                  <p class="card-text venue-address mb-2"><i class="fas fa-map-marker-alt me-2"></i>{{ venue.venue_location }}</p>
                  <p class="card-text venue-type mb-2"><small class="text-muted">{{ venue.venue_type }}</small></p>
                  
                  <div class="venue-description-container flex-grow-1">
                    <p class="card-text venue-description">{{ truncate(venue.venue_description, 100) }}</p>
                    <button class="cta-button venue-btn read-more-btn" @click="showDescriptionModal(venue)">Read more</button>
                  </div>
                  
                  <div class="venue-sensory-details mt-2">
                    <p class="mb-1 small"><strong>Sensory Features:</strong></p>
                    <p class="small sensory-features-text">{{ truncate(venue.venue_sensory_type, 80) || 'Details not specified' }}</p>
                  </div>
                </div>
                <div class="card-footer bg-transparent border-top-0 pb-3">
                  <a v-if="venue.venue_sensory_info_link" :href="venue.venue_sensory_info_link" target="_blank" rel="noopener noreferrer" class="cta-button venue-btn w-100">
                    View Sensory Map/Info <i class="fas fa-external-link-alt ms-1"></i>
                  </a>
                  <p v-else class="text-muted text-center small mb-0">No sensory map link available</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- info card area - occupies right 4 columns -->
        <div class="col-lg-4">
          <!-- first info card -->
          <div class="info-card mb-4" data-aos="fade-left">
            <div class="info-card-img-container">
              <img src="@/assets/sensory-hours.png" alt="Sensory-Friendly Hours" class="info-card-img">
            </div>
            <div class="info-card-body">
              <h3 class="info-card-title">Sensory-Friendly Hours or Sessions</h3>
              <p class="info-card-text">
                These are designated times when venues adjust their environment to reduce sensory overload. 
                During these sessions, lights may be dimmed, background noise reduced, crowds limited, and announcements silenced.
              </p>
              <p class="info-card-text">
                They're ideal for families who prefer quieter, more predictable environments.
              </p>
            </div>
          </div>
          
          <!-- second info card -->
          <div class="info-card" data-aos="fade-left" data-aos-delay="200">
            <div class="info-card-img-container">
              <img src="@/assets/staff-trained.png" alt="Staff Trained in Autism Support" class="info-card-img">
            </div>
            <div class="info-card-body">
              <h3 class="info-card-title">Staff Trained in Autism Support</h3>
              <p class="info-card-text">
                Staff at these venues have received training in how to support neurodivergent individuals. 
                They understand how to respond calmly to sensory distress, use inclusive communication, 
                and help families access quiet spaces or necessary tools.
              </p>
              <p class="info-card-text">
                This can make a big difference in reducing anxiety during a visit.
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Pagination with consistent styling -->
      <nav v-if="totalPages > 1 && !isLoading" aria-label="Venue navigation" class="mt-5 d-flex justify-content-center">
        <ul class="pagination pagination-custom">
          <li class="page-item" :class="{ disabled: currentPage === 1 }">
            <button class="page-link" @click="changePage(currentPage - 1)" aria-label="Previous">«</button>
          </li>
          <li v-for="pageNumber in paginationRange" :key="pageNumber" class="page-item" :class="{ active: pageNumber === currentPage, disabled: pageNumber === '...' }">
            <button v-if="pageNumber !== '...'" class="page-link" @click="changePage(pageNumber)">{{ pageNumber }}</button>
             <span v-else class="page-link">...</span>
          </li>
          <li class="page-item" :class="{ disabled: currentPage === totalPages }">
            <button class="page-link" @click="changePage(currentPage + 1)" aria-label="Next">»</button>
          </li>
        </ul>
      </nav>

    </div>

    <!-- Description Modal with consistent styling -->
    <div class="modal fade" id="descriptionModal" tabindex="-1" aria-labelledby="descriptionModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="descriptionModalLabel">{{ selectedVenue?.venue_title }}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>{{ selectedVenue?.venue_description }}</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="cta-button venue-btn" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    </div>

    <!-- FAQ Section -->
    <div class="faq-section container mb-5">
      <h2 class="faq-title">FAQs</h2>
      
      <div class="accordion" id="faqAccordion">
        <!-- FAQ Item 1 -->
        <div class="accordion-item">
          <h2 class="accordion-header" id="headingOne">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
              <div class="faq-question">What is a Sensory Map?</div>
            </button>
          </h2>
          <div id="collapseOne" class="accordion-collapse collapse" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
            <div class="accordion-body">
              <p>A sensory map highlights spaces in a venue that support sensory needs. It helps families find calm zones, quiet areas, and sensory-friendly features.</p>
            </div>
          </div>
        </div>
        
        <!-- FAQ Item 2 -->
        <div class="accordion-item">
          <h2 class="accordion-header" id="headingTwo">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
              <div class="faq-question">Why is the Sensory Map useful for my child?</div>
            </button>
          </h2>
          <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
            <div class="accordion-body">
              <p>It helps reduce uncertainty. By knowing where calming spaces are in advance, you and your child can plan breaks, avoid stressful spots, and feel more confident.</p>
            </div>
          </div>
        </div>
        
        <!-- FAQ Item 3 -->
        <div class="accordion-item">
          <h2 class="accordion-header" id="headingThree">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
              <div class="faq-question">What should I look for when I open the Sensory Map?</div>
            </button>
          </h2>
          <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
            <div class="accordion-body">
              <p>Look for labels such as:</p>
              <ul class="faq-list">
                <li><span class="faq-icon">🕰️</span> Sensory-Friendly Hours</li>
                <li><span class="faq-icon">🛋️</span> Quiet Rooms</li>
                <li><span class="faq-icon">🎧</span> Sensory Tools</li>
                <li><span class="faq-icon">🤝</span> Staff Trained in Autism Support</li>
                <li><span class="faq-icon">🟡</span> Low Sensory Zones</li>
                <li><span class="faq-icon">🟣</span> Sensory Opportunities</li>
              </ul>
              <p>These help you find supportive spaces during your visit.</p>
            </div>
          </div>
        </div>
        
        <!-- FAQ Item 4 -->
        <div class="accordion-item">
          <h2 class="accordion-header" id="headingFour">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
              <div class="faq-question">Are the sensory features always available?</div>
            </button>
          </h2>
          <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#faqAccordion">
            <div class="accordion-body">
              <p>Some features, like Quiet Rooms or Low Sensory Hours, may be available only during specific times. It's best to check with the venue directly before your visit.</p>
            </div>
          </div>
        </div>
        
        <!-- FAQ Item 5 -->
        <div class="accordion-item">
          <h2 class="accordion-header" id="headingFive">
            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFive" aria-expanded="false" aria-controls="collapseFive">
              <div class="faq-question">Can I use the Sensory Map to plan with my child?</div>
            </button>
          </h2>
          <div id="collapseFive" class="accordion-collapse collapse" aria-labelledby="headingFive" data-bs-parent="#faqAccordion">
            <div class="accordion-body">
              <p>Yes! You can explore the map together before your visit and talk through where they might feel safe or need a break. It builds predictability and reduces anxiety.</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <MyFooter />
  </div>
</template>

<script setup>
import { ref, onMounted, watch, computed, nextTick } from 'vue';
import axios from 'axios';
import AOS from 'aos';
import 'aos/dist/aos.css';
import MyNavBar from '../components/test/MyNavBar.vue'; // Adjust path
import MyFooter from '../components/test/MyFooter.vue'; // Adjust path
import { debounce } from 'lodash-es'; // Import debounce
import { Modal } from 'bootstrap';

// --- State ---
const venues = ref([]);
const isLoading = ref(false);
const error = ref(null);
const searchQuery = ref('');
const selectedSensoryCategory = ref(null);
const selectedLocation = ref(null);
const selectedVenueType = ref(null);
const venueTypes = ref([]);
const locations = ref([]);
const sensoryCategories = ref([]);
const currentPage = ref(1);
const totalPages = ref(1);
const limit = ref(4); // Items per page

const API_BASE_URL = '/api';

// add selectedVenue state
const selectedVenue = ref(null);
let descriptionModal = null;

// check if there are any filters
const isFiltered = computed(() => {
  return searchQuery.value || selectedSensoryCategory.value || selectedLocation.value || selectedVenueType.value;
});

// --- Methods ---

const fetchVenues = async (page = currentPage.value) => {
  isLoading.value = true;
  error.value = null;
  currentPage.value = page; // Update current page state

  const params = {
    search: searchQuery.value || undefined, // Send only if not empty
    sensoryCategory: selectedSensoryCategory.value || undefined,
    location: selectedLocation.value || undefined,
    venueType: selectedVenueType.value || undefined,
    page: currentPage.value,
    limit: limit.value
  };
  // Remove undefined params
  Object.keys(params).forEach(key => params[key] === undefined && delete params[key]);

  console.log("Fetching venues with params:", params);
  try {
    const response = await axios.get(`${API_BASE_URL}/sensory-venues`, { params });
    if (response.data.success) {
      venues.value = response.data.data.venues;
      totalPages.value = response.data.data.totalPages;
      // Ensure currentPage isn't greater than totalPages after filtering
      if (currentPage.value > totalPages.value) {
          currentPage.value = totalPages.value > 0 ? totalPages.value : 1;
          // Optionally re-fetch if page changed, though often backend handles offset correctly
      }
      console.log(`Venues loaded. Total Pages: ${totalPages.value}, Current Page: ${currentPage.value}`);
    } else {
      throw new Error(response.data.error || 'Failed to fetch venues from API');
    }
  } catch (err) {
    console.error("Error fetching venues:", err);
    error.value = err.message || "An unknown error occurred while fetching venues.";
    venues.value = [];
    totalPages.value = 1;
  } finally {
    isLoading.value = false;
  }
};

// Debounced version of fetchVenues, specifically for search input
const debouncedFetchVenues = debounce(() => {
    fetchVenues(1); // Reset to page 1 when search query changes
}, 500); // 500ms delay


const fetchFilterOptions = async () => {
    try {
        const [typesRes, locRes, catRes] = await Promise.all([
            axios.get(`${API_BASE_URL}/sensory-venues/types`),
            axios.get(`${API_BASE_URL}/sensory-venues/locations`),
            axios.get(`${API_BASE_URL}/sensory-venues/sensory-categories`)
        ]);
        if (typesRes.data.success) venueTypes.value = typesRes.data.data;
        if (locRes.data.success) locations.value = locRes.data.data;
        if (catRes.data.success) sensoryCategories.value = catRes.data.data;
        console.log("Filter options loaded:", { types: venueTypes.value.length, locs: locations.value.length, cats: sensoryCategories.value.length });
    } catch (err) {
        console.error("Error fetching filter options:", err);
        // Handle error - maybe show a message?
        error.value = "Could not load filter options.";
    }
};

// Called when filters (dropdowns) change or search is entered explicitly
const applyFilters = () => {
    fetchVenues(1); // Reset to page 1 and fetch
};

const changePage = (newPage) => {
    if (newPage >= 1 && newPage <= totalPages.value && newPage !== currentPage.value) {
        fetchVenues(newPage);
    }
};

// Helper to truncate text
const truncate = (text, length) => {
    if (!text) return '';
    if (text.length <= length) return text;
    return text.substring(0, length) + '...';
};

const handleImageError = (event) => {
  console.warn(`Image failed to load: ${event.target.src}. Using placeholder.`);
  // use the correct backend image path
  event.target.src = '/image/ngv.png';
};

const getImageUrl = (venue) => {
  // 首选完整URL (如果有)
  if (venue.image_full_url && venue.image_full_url.startsWith('http')) {
    return venue.image_full_url;
  }
  
  // 如果image_full_url存在但不是完整URL (可能只是路径)
  if (venue.image_full_url) {
    // 检查是否已经包含/image/前缀
    if (venue.image_full_url.startsWith('/image/')) {
      return `${venue.image_full_url}`;
    } else {
      return `/image/${venue.image_full_url}`;
    }
  }
  
  // 如果只有image_url (无前缀)
  if (venue.image_url) {
    return `/image/${venue.image_url}`;
  }
  
  // 兜底使用默认图片
  return '/image/ngv.png';
};

// --- Computed ---
// Generate pagination numbers with ellipsis
const paginationRange = computed(() => {
    const current = currentPage.value;
    const last = totalPages.value;
    const delta = 1; // How many pages around current page
    const left = current - delta;
    const right = current + delta + 1;
    const range = [];
    const rangeWithDots = [];

    for (let i = 1; i <= last; i++) {
        if (i === 1 || i === last || (i >= left && i < right)) {
            range.push(i);
        }
    }

    let l;
    for (let i of range) {
        if (l) {
            if (i - l === 2) {
                rangeWithDots.push(l + 1);
            } else if (i - l > 2) {
                rangeWithDots.push('...');
            }
        }
        rangeWithDots.push(i);
        l = i;
    }

    return rangeWithDots;
});

// location data grouped by region
const locationsByRegion = computed(() => {
  const grouped = {
    'Melbourne CBD': [],
    'Inner Suburbs': [],
    'Eastern Suburbs': [],
    'Other Areas': []
  };
  
  // assign to different regions based on address
  locations.value.forEach(loc => {
    if (loc.includes('Melbourne') && (loc.includes('3000') || loc.includes('3006'))) {
      grouped['Melbourne CBD'].push(loc);
    } else if (loc.includes('Carlton') || loc.includes('Parkville') || 
               loc.includes('Docklands') || loc.includes('Spotswood')) {
      grouped['Inner Suburbs'].push(loc);
    } else if (loc.includes('Malvern') || loc.includes('Burwood')) {
      grouped['Eastern Suburbs'].push(loc);
    } else {
      grouped['Other Areas'].push(loc);
    }
  });
  
  // filter out empty arrays
  Object.keys(grouped).forEach(key => {
    if (grouped[key].length === 0) {
      delete grouped[key];
    }
  });
  
  return grouped;
});

// --- Lifecycle Hooks ---
onMounted(() => {
  fetchFilterOptions();
  fetchVenues(1); // Fetch initial data on page 1
  AOS.init({ duration: 600, once: true, offset: 50 }); // Animate once
});

// --- Watchers ---
// Watch search query with debounce
watch(searchQuery, () => {
    debouncedFetchVenues();
});

// Watch filters (no debounce needed for selects typically)
// watch([selectedSensoryCategory, selectedLocation, selectedVenueType], () => {
//     applyFilters(); // applyFilters already resets to page 1
// });
// Note: The @change="applyFilters" on the selects handles this directly now.

// show description modal
const showDescriptionModal = (venue) => {
  selectedVenue.value = venue;
  // ensure DOM is loaded
  nextTick(() => {
    if (!descriptionModal) {
      descriptionModal = new Modal(document.getElementById('descriptionModal'));
    }
    descriptionModal.show();
  });
};

// clear search query
const clearSearchQuery = () => {
  searchQuery.value = '';
  applyFilters();
};

// select sensory feature
const selectSensoryFeature = (category) => {
  selectedSensoryCategory.value = category;
  applyFilters();
};

// clean all filters
const clearAllFilters = () => {
  searchQuery.value = '';
  selectedSensoryCategory.value = null;
  fetchVenues(1);
};

</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css');

:root {
  --background-main: #F8EFED;
  --text-brown: #4d2f20;
  --primary-green: #3E5C2B;
  --card-bg: #FFFFFF;
  --border-color: #e0e0e0;
}

.venue-finder-page {
  background-color: var(--background-main);
  min-height: 100vh;
  font-family: 'Inter', sans-serif;
}

/* new hero banner style */
.hero-banner {
  position: relative;
  width: 100%;
  height: 500px;
  overflow: hidden;
  margin-bottom: 0;
}

.hero-image-container {
  width: 100%;
  height: 100%;
}

.hero-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center 50%;
}

.hero-text-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.5);
}

.text-center {
  text-align: center;
}

.main-title { 
  color: #4d2f20 !important;
  font-size: 2.7rem; 
  font-weight: 700; 
  margin-bottom: 1rem; 
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

.main-subtitle { 
  color: #4d2f20 !important;
  font-size: 1.3rem; 
  margin-bottom: 0; 
  line-height: 1.6;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
}

/* search container style */
.search-container {
  background-color: #f8f9fa;
  padding-top: 0;
  padding-bottom: 3rem;
}

.search-container .container,
.results-section.container {
  max-width: 1200px;
  margin: 0 auto;
}

/* Filter Section */
.filter-section {
  background-color: white;
  border-radius: 12px;
  box-shadow: 0 3px 10px rgba(0,0,0,0.07);
  position: relative;
  z-index: 10;
  padding: 1.5rem;
  margin-top: -20px;
}
.filter-select, .form-control {
    border-radius: 8px;
    border-color: #ddd;
    padding: 0.5rem 1rem;
    font-size: 0.95rem;
}
.input-group-text { 
    background-color: #f8f9fa; 
    border-right: 0; 
    color: var(--primary-green);
}
.form-control { border-left: 0; }

/* Results Section */
.results-section { padding-top: 2rem; }
.venue-card {
    transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    border: 1px solid var(--border-color);
    border-radius: 10px;
    overflow: hidden;
    background-color: white;
    height: 100%;
    display: flex;
    flex-direction: column;
}
.venue-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.1);
}
.venue-image {
    height: 200px;
    object-fit: cover;
    width: 100%;
}
.venue-title { 
    color: var(--text-brown); 
    font-weight: 600; 
    font-size: 1.25rem; 
    margin-bottom: 0.5rem; 
}
.venue-address { color: #555; font-size: 0.9rem; display: flex; align-items: center; }
.venue-address i { color: var(--primary-green); }
.venue-type small { 
    background-color: #f0f0f0; 
    padding: 2px 6px; 
    border-radius: 4px; 
    font-size: 0.75rem;
}

/* Description Container */
.venue-description-container {
  margin-bottom: 1rem;
  display: flex;
  flex-direction: column;
}

.venue-description {
  font-size: 0.9rem;
  line-height: 1.5;
  color: #444;
  margin-bottom: 1rem;
  flex-grow: 1;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Consistent Button Styling */
.cta-button { 
  display: inline-block; 
  padding: 8px 20px; 
  border: none; 
  border-radius: 50px; 
  font-size: 0.95rem; 
  font-weight: 600; 
  text-decoration: none; 
  cursor: pointer; 
  transition: all 0.3s ease; 
  text-align: center;
  background-color: #3E5C2B !important; 
  color: #ffffff !important;
}

.cta-button:hover { 
  background-color: #4d7234 !important; 
  color: #ffffff !important; 
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.venue-btn {
  font-size: 0.9rem;
  padding: 7px 18px;
  background-color: #3E5C2B !important;
  color: #ffffff !important;
}

.read-more-btn {
  font-size: 0.85rem;
  padding: 5px 15px;
  width: auto;
  align-self: flex-start;
  margin-top: 0.25rem;
}

.card-footer { 
  padding-top: 0;
  margin-top: auto;
}

/* Pagination Styling */
.pagination .page-item.active .page-link {
    background-color: var(--primary-green);
    border-color: var(--primary-green);
    color: white;
}
.pagination .page-link {
    color: var(--primary-green);
}

/* Modal Styling */
.modal-title {
  color: var(--text-brown);
  font-weight: 600;
}

.modal-body p {
  color: #555;
  line-height: 1.6;
}

/* Form Select Styling */
.form-select optgroup {
  font-weight: bold;
  color: var(--primary-green);
}

.form-select option {
  padding: 4px;
  font-size: 0.95rem;
}

/* Loading/Error Styling */
.text-primary-custom { 
  color: var(--primary-green) !important; 
}

.loading-text { 
  color: var(--text-brown); 
}

/* Font Awesome Icons */
.venue-sensory-details { 
  border-top: 1px dashed #eee; 
  padding-top: 0.5rem;
}

.sensory-features-text {
  color: #333;
  height: 3rem;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

/* custom pagination style */
.pagination-custom {
  display: flex;
  padding-left: 0;
  list-style: none;
  border-radius: 0.25rem;
}

.pagination-custom .page-item .page-link {
  position: relative;
  display: block;
  padding: 0.75rem 1rem;
  margin-left: -1px;
  line-height: 1.25;
  color: #4d2f20;
  background-color: #fff;
  border: 1px solid #dee2e6;
  transition: all 0.3s ease;
}

.pagination-custom .page-item:first-child .page-link {
  margin-left: 0;
  border-top-left-radius: 0.25rem;
  border-bottom-left-radius: 0.25rem;
}

.pagination-custom .page-item:last-child .page-link {
  border-top-right-radius: 0.25rem;
  border-bottom-right-radius: 0.25rem;
}

.pagination-custom .page-item .page-link:hover {
  z-index: 2;
  color: #fff;
  text-decoration: none;
  background-color: #4d2f20;
  border-color: #4d2f20;
}

.pagination-custom .page-item.active .page-link {
  z-index: 3;
  color: #fff;
  background-color: #4d2f20;
  border-color: #4d2f20;
}

.pagination-custom .page-item.disabled .page-link {
  color: #6c757d;
  pointer-events: none;
  cursor: auto;
  background-color: #fff;
  border-color: #dee2e6;
}

/* search bar enhanced style */
.search-box-container {
  margin-bottom: 0.5rem;
}

.search-tips {
  margin-top: 8px;
  color: #6c757d;
  text-align: left;
  padding-left: 8px;
}

.search-input-group {
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid #3E5C2B;
  box-shadow: 0 3px 8px rgba(0,0,0,0.08);
}

.search-input {
  border: none;
  color: #4d2f20;
  font-size: 1rem;
  padding: 0.6rem 1rem;
  height: 50px;
}

.search-input::placeholder {
  color: #4d2f20;
  opacity: 0.7;
}

.search-input:focus {
  box-shadow: none;
  border-color: #3E5C2B;
  color: #4d2f20;
}

.btn-search {
  background-color: #3E5C2B;
  color: white;
  border: none;
  padding: 0.6rem 1.5rem;
  font-weight: 600;
  min-width: 110px;
  transition: all 0.3s ease;
  border-top-right-radius: 8px;
  border-bottom-right-radius: 8px;
}

.btn-search:hover {
  background-color: #4d7234;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.search-icon {
  background-color: white;
  border: none;
  color: #3E5C2B;
  padding: 0.6rem 1rem;
  font-size: 1.1rem;
}

/* filter card */
.filter-card {
  background-color: white;
  border-radius: 10px;
  padding: 15px 20px;
  box-shadow: 0 3px 8px rgba(0,0,0,0.08);
  border-left: 4px solid #3E5C2B;
  margin-bottom: 1rem;
}

.filter-content {
  display: flex;
  align-items: center;
}

.filter-label {
  color: var(--text-brown);
  font-weight: 600;
  font-size: 1rem;
}

.filter-chips-container {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  justify-content: flex-start;
}

.filter-chip {
  background-color: #f8f9fa;
  border: 1px solid #dee2e6;
  color: #4d2f20;
  padding: 8px 15px;
  border-radius: 20px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.2s ease;
  font-weight: 500;
  margin-bottom: 5px;
}

.filter-chip:hover {
  background-color: #e9ecef;
  border-color: #3E5C2B;
  transform: translateY(-2px);
}

.filter-chip.active {
  background-color: #3E5C2B;
  color: white;
  border-color: #3E5C2B;
  font-weight: 600;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.clear-input-btn {
  background-color: white;
  border: none;
  color: #6c757d;
  cursor: pointer;
  transition: all 0.2s ease;
}

.clear-input-btn:hover {
  color: #dc3545;
}

/* search result header enhanced */
.search-result-header {
  background-color: #f8f7f6;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 3px 10px rgba(0,0,0,0.1);
  border-left: 4px solid #3E5C2B;
  margin-top: 1rem;
  margin-bottom: 2rem;
}

.search-results-title {
  color: #4d2f20;
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0;
  display: flex;
  align-items: center;
}

.search-results-title i {
  color: #3E5C2B;
}

.search-summary {
  margin-top: 10px;
  color: #666;
  font-size: 0.95rem;
}

.search-summary strong {
  color: #3E5C2B;
  font-weight: 600;
}

/* clear search button enhanced */
.clear-search-btn {
  background-color: #f8f9fa;
  color: #4d2f20;
  border: 1px solid #3E5C2B;
  border-radius: 20px;
  padding: 8px 20px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.clear-search-btn:hover {
  background-color: #3E5C2B;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

/* info card style */
.info-card {
  background-color: #f8f7f0;
  border-radius: 15px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  display: flex;
  flex-direction: column;
  height: auto;
  border-left: 5px solid #3E5C2B;
  position: relative;
  padding-top: 40px;
}

.info-card::before {
  content: "SENSORY FEATURES";
  position: absolute;
  top: 12px;
  left: 18px;
  font-size: 0.75rem;
  font-weight: 700;
  color: #3E5C2B;
  letter-spacing: 1px;
  text-transform: uppercase;
  background-color: rgba(62, 92, 43, 0.1);
  padding: 3px 8px;
  border-radius: 4px;
}

.info-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
}

.info-card-img-container {
  position: relative;
  width: 100%;
  padding-top: 60%; /* 长宽比3:5 */
  background-color: #ffffff;
  overflow: hidden;
  border-bottom: 2px dashed rgba(62, 92, 43, 0.2);
}

.info-card-img {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 10px;
}

.info-card-body {
  padding: 1.5rem;
}

.info-card-title {
  color: var(--text-brown);
  font-size: 1.4rem;
  font-weight: 600;
  margin-bottom: 1rem;
  border-bottom: 2px solid rgba(62, 92, 43, 0.2);
  padding-bottom: 0.5rem;
}

.info-card-text {
  color: #555;
  font-size: 0.95rem;
  line-height: 1.6;
  margin-bottom: 0.75rem;
  font-style: italic;
}

/* responsive adjustment */
@media (max-width: 991.98px) {
  .info-card-img-container {
    padding-top: 66.67%;
  }
}

@media (max-width: 767.98px) {
  .info-card-img-container {
    padding-top: 75%; /* 3:4比例 */
  }
}

@media (max-width: 768px) {
  .filter-content {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .filter-label {
    margin-bottom: 10px;
  }
}

/* FAQ section style */
.faq-section {
  padding-top: 3rem;
  background-color: transparent;
}

.faq-title {
  color: var(--text-brown);
  font-size: 2.2rem;
  font-weight: 700;
  text-align: center;
  margin-bottom: 2rem;
  position: relative;
  padding-bottom: 1rem;
}

.faq-title::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 4px;
  background-color: var(--primary-green);
  border-radius: 2px;
}

.accordion {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 15px rgba(0,0,0,0.08);
}

.accordion-item {
  border: none;
  border-bottom: 1px solid #eee;
  background-color: white;
}

.accordion-item:last-child {
  border-bottom: none;
}

.accordion-button {
  padding: 1.2rem 1.5rem;
  color: var(--text-brown);
  font-weight: 600;
  font-size: 1.1rem;
  background-color: white;
  border-radius: 0 !important;
  box-shadow: none !important;
}

.accordion-button:focus {
  box-shadow: none;
  border-color: rgba(0,0,0,.125);
}

.accordion-button:not(.collapsed) {
  color: var(--primary-green);
  background-color: rgba(62, 92, 43, 0.05);
  box-shadow: none;
}

.accordion-button:not(.collapsed)::after {
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%233E5C2B'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
  transform: rotate(-180deg);
}

.accordion-body {
  padding: 1rem 1.5rem 1.5rem;
  background-color: rgba(248, 247, 240, 0.3);
  color: #555;
  line-height: 1.6;
  font-size: 1rem;
}

.faq-question {
  position: relative;
  padding-left: 15px;
}

.faq-question::before {
  content: "";
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background-color: var(--primary-green);
}

.faq-list {
  list-style: none;
  padding-left: 0;
  margin-left: 1rem;
  margin-top: 1rem;
  margin-bottom: 1rem;
}

.faq-list li {
  margin-bottom: 0.7rem;
  position: relative;
  padding-left: 2.5rem;
  display: flex;
  align-items: center;
}

.faq-icon {
  position: absolute;
  left: 0;
  font-size: 1.3rem;
  margin-right: 0.5rem;
}

@media (max-width: 768px) {
  .faq-title {
    font-size: 1.8rem;
  }
  
  .accordion-button {
    font-size: 1rem;
    padding: 1rem 1.2rem;
  }
  
  .accordion-body {
    padding: 1rem;
    font-size: 0.95rem;
  }
}
</style>