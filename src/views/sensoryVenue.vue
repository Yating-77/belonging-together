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
            <div class="row g-3 justify-content-center">
              <!-- Search Bar -->
              <div class="col-lg-4 col-md-12">
                <div class="input-group search-input-group">
                  <span class="input-group-text search-icon"><i class="fas fa-search"></i></span>
                  <input
                    type="text"
                    class="form-control search-input"
                    placeholder="Search by name or keyword..."
                    v-model.lazy="searchQuery"
                    @keyup.enter="applyFilters"
                  />
                </div>
              </div>
              <!-- Filters -->
              <div class="col-lg-8 col-md-12">
                <div class="row g-2">
                  <div class="col-md-4 col-sm-12">
                    <select class="form-select filter-select" v-model="selectedSensoryCategory" @change="applyFilters">
                      <option :value="null">All Sensory Features</option>
                      <option v-for="cat in sensoryCategories" :key="cat" :value="cat">{{ cat }}</option>
                    </select>
                  </div>
                  <div class="col-md-4 col-sm-6">
                    <select class="form-select filter-select" v-model="selectedLocation" @change="applyFilters">
                      <option :value="null">All Locations</option>
                      <optgroup v-if="locationsByRegion['Melbourne CBD']" label="Melbourne CBD">
                        <option v-for="loc in locationsByRegion['Melbourne CBD']" :key="loc" :value="loc">{{ loc }}</option>
                      </optgroup>
                      <optgroup v-if="locationsByRegion['Inner Suburbs']" label="Inner Suburbs">
                        <option v-for="loc in locationsByRegion['Inner Suburbs']" :key="loc" :value="loc">{{ loc }}</option>
                      </optgroup>
                      <optgroup v-if="locationsByRegion['Eastern Suburbs']" label="Eastern Suburbs">
                        <option v-for="loc in locationsByRegion['Eastern Suburbs']" :key="loc" :value="loc">{{ loc }}</option>
                      </optgroup>
                      <optgroup v-if="locationsByRegion['Other Areas']" label="Other Areas">
                        <option v-for="loc in locationsByRegion['Other Areas']" :key="loc" :value="loc">{{ loc }}</option>
                      </optgroup>
                    </select>
                  </div>
                  <div class="col-md-4 col-sm-6">
                    <select class="form-select filter-select" v-model="selectedVenueType" @change="applyFilters">
                      <option :value="null">All Venue Types</option>
                      <option v-for="type in venueTypes" :key="type" :value="type">{{ type }}</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
  
      <!-- Results Section with consistent styling -->
      <div class="results-section container mb-5">
        <!-- 搜索结果标题栏 -->
        <div v-if="isFiltered" class="search-result-header mb-4">
          <div class="d-flex justify-content-between align-items-center">
            <h2 class="search-results-title">Search Results</h2>
            <button class="clear-search-btn" @click="clearAllFilters">
              <i class="fas fa-undo me-1"></i> Clear Search
            </button>
          </div>
          <p class="search-summary mb-0">
            <span v-if="searchQuery">Keyword: <strong>{{ searchQuery }}</strong></span>
            <span v-if="selectedSensoryCategory"> | Sensory Feature: <strong>{{ selectedSensoryCategory }}</strong></span>
            <span v-if="selectedLocation"> | Location: <strong>{{ selectedLocation }}</strong></span>
            <span v-if="selectedVenueType"> | Venue Type: <strong>{{ selectedVenueType }}</strong></span>
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
  
        <!-- Venues Grid with Info Cards - 使用两列布局 -->
        <div v-else class="row g-4">
          <!-- 场馆卡片区域 - 占据左侧8列 -->
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
          
          <!-- 信息卡片区域 - 占据右侧4列 -->
          <div class="col-lg-4">
            <!-- 第一个信息卡片 -->
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
            
            <!-- 第二个信息卡片 -->
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
  
  // 添加 selectedVenue 状态
  const selectedVenue = ref(null);
  let descriptionModal = null;
  
  // 判断是否有过滤条件
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
    // 修改为正确的后端图片路径
    event.target.src = '/image/ngv.jpg';
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
    return '/image/ngv.jpg';
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
  
  // 地区分组数据
  const locationsByRegion = computed(() => {
    const grouped = {
      'Melbourne CBD': [],
      'Inner Suburbs': [],
      'Eastern Suburbs': [],
      'Other Areas': []
    };
    
    // 根据地址分配到不同区域
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
    
    // 过滤掉空数组
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
  
  // 显示描述弹窗
  const showDescriptionModal = (venue) => {
    selectedVenue.value = venue;
    // 确保DOM已加载
    nextTick(() => {
      if (!descriptionModal) {
        descriptionModal = new Modal(document.getElementById('descriptionModal'));
      }
      descriptionModal.show();
    });
  };
  
  // 清除所有筛选条件
  const clearAllFilters = () => {
    searchQuery.value = '';
    selectedSensoryCategory.value = null;
    selectedLocation.value = null;
    selectedVenueType.value = null;
    
    // 重新获取数据
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
  
  /* 新的Hero Banner样式 */
  .hero-banner {
    position: relative;
    width: 100%;
    height: 500px; /* 从400px增加到500px */
    overflow: hidden;
    margin-bottom: 0; /* 移除底部边距 */
  }
  
  .hero-image-container {
    width: 100%;
    height: 100%;
  }
  
  .hero-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center 50%; /* 图片中心偏上 */
  }
  
  .hero-text-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center; /* 水平居中 */
    background: rgba(255, 255, 255, 0.5); /* 半透明白色背景 */
  }
  
  .text-center {
    text-align: center;
  }
  
  .main-title { 
    color: #4d2f20 !important; /* 确保使用棕色 */
    font-size: 2.7rem; 
    font-weight: 700; 
    margin-bottom: 1rem; 
    text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
  }
  
  .main-subtitle { 
    color: #4d2f20 !important; /* 确保使用棕色 */
    font-size: 1.3rem; 
    margin-bottom: 0; 
    line-height: 1.6;
    max-width: 800px;
    margin-left: auto;
    margin-right: auto;
    text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.8);
  }
  
  /* 搜索容器样式 */
  .search-container {
    background-color: #f8f9fa;
    padding-top: 0;
    padding-bottom: 3rem;
  }
  
  /* Filter Section */
  .filter-section {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.07);
    position: relative;
    z-index: 10;
    padding: 1.5rem;
    margin-top: -20px; /* 向上偏移以减少空白 */
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
  
  /* 自定义分页样式 */
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
  
  /* 搜索栏样式 */
  .search-input-group {
    border-radius: 8px;
    overflow: hidden;
    border: 1px solid #3E5C2B;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  }
  
  .search-input-group .search-icon {
    background-color: #3E5C2B;
    border: none;
    color: #ffffff;
    padding: 0.6rem 1rem;
  }
  
  .search-input {
    border: none;
    color: #4d2f20;
    font-size: 0.95rem;
    padding: 0.6rem 1rem;
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
  
  /* 下拉菜单样式调整 */
  .filter-select {
    border: 1px solid #3E5C2B;
    color: #4d2f20;
    padding: 0.6rem 1rem;
    background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%233E5C2B' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M2 5l6 6 6-6'/%3e%3c/svg%3e");
  }
  
  .filter-select:focus {
    border-color: #3E5C2B;
    box-shadow: 0 0 0 0.25rem rgba(62, 92, 43, 0.25);
  }
  
  /* 信息卡片样式 */
  .info-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    display: flex;
    flex-direction: column;
    height: auto;
  }
  
  .info-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 24px rgba(0,0,0,0.12);
  }
  
  .info-card-img-container {
    position: relative;
    width: 100%;
    padding-top: 60%; /* 长宽比3:5 */
    background-color: #f8f9fa;
    overflow: hidden;
  }
  
  .info-card-img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: contain;
  }
  
  .info-card-body {
    padding: 1.5rem;
  }
  
  .info-card-title {
    color: var(--text-brown);
    font-size: 1.4rem;
    font-weight: 600;
    margin-bottom: 1rem;
  }
  
  .info-card-text {
    color: #555;
    font-size: 0.95rem;
    line-height: 1.6;
    margin-bottom: 0.75rem;
  }
  
  /* 响应式调整 */
  @media (max-width: 991.98px) {
    .info-card-img-container {
      padding-top: 66.67%; /* 2:3比例 */
    }
  }
  
  @media (max-width: 767.98px) {
    .info-card-img-container {
      padding-top: 75%; /* 3:4比例 */
    }
  }
  
  /* 搜索结果区域样式 */
  .search-result-header {
    background-color: #f8f7f6;
    border-radius: 8px;
    padding: 15px 20px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    border-left: 4px solid var(--primary-green);
  }
  
  .search-results-title {
    font-size: 1.4rem;
    color: var(--text-brown);
    margin-bottom: 0;
  }
  
  .search-summary {
    font-size: 0.9rem;
    color: #666;
    margin-top: 8px;
  }
  
  .search-summary strong {
    color: var(--primary-green);
    font-weight: 600;
  }
  
  .clear-search-btn {
    background-color: transparent;
    color: var(--primary-green);
    border: 1px solid var(--primary-green);
    border-radius: 20px;
    padding: 5px 15px;
    font-size: 0.85rem;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  
  .clear-search-btn:hover {
    background-color: var(--primary-green);
    color: #3E5C2B;
  }
  </style>