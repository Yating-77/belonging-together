<template>
  <div class="resource-page">
    <MyNavBar />
    <!-- Top banner area -->
    <div class="hero-banner">
      <div class="hero-content">
        <h1 class="hero-title">Be Informed and Inspired</h1>

      </div>
    </div>

    <!-- Search area -->
    <div class="search-container">
      <div class="search-wrapper">

        <div class="keyword-search">
          <label>Keyword search</label>
          <input 
            v-model="searchKeyword" 
            type="text" 
            class="form-control" 
            placeholder="Enter your keyword" 
            @keyup.enter="searchArticles"
          />
          <button class="search-button" @click="searchArticles">Search</button>
        </div>
      </div>
    </div>

    <!-- Search results area - 移到最受欢迎文章之前 -->
    <div v-if="isSearchResult" class="search-results-section">
      <div class="container">
        <h2 class="section-title">Search Results</h2>

        <!-- Search results tips -->
        <div v-if="!loadingSearch && !errorSearch && searchResults.length > 0" class="search-result-info">
          Found {{ searchResults.length }} articles related to "{{ lastSearchKeyword }}"
          <button class="reset-search-btn" @click="resetSearch">Clear search results</button>
        </div>

        <div v-if="loadingSearch" class="loading-spinner">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Searching...</span>
          </div>
        </div>
        
        <div v-else-if="errorSearch" class="alert alert-danger">
          {{ errorSearch }}
          <button class="reset-search-btn" @click="resetSearch">Clear search results</button>
        </div>
        
        <!-- Use the same Swiper component format as the main list -->
        <div v-else-if="!loadingSearch && !errorSearch && searchResults.length > 0" class="swiper-container">
          <div class="swiper-button-prev custom-nav-prev search-nav-prev"></div>
          <swiper
            :modules="swiperModules"
            :slides-per-view="3"
            :space-between="20"
            :navigation="{
              nextEl: '.search-nav-next',
              prevEl: '.search-nav-prev'
            }"
            :pagination="{ 
              clickable: true,
              el: '.search-pagination'
            }"
            :breakpoints="swiperBreakpoints"
            class="article-slider"
          >
            <swiper-slide v-for="article in searchResults" :key="'search-' + article.id">
              <article-card :article="article" />
            </swiper-slide>
          </swiper>
          <div class="swiper-button-next custom-nav-next search-nav-next"></div>
          <div class="swiper-pagination search-pagination"></div>
        </div>
        
        <!-- No results found prompt -->
        <div v-else-if="!loadingSearch && !errorSearch && searchResults.length === 0" class="search-result-info">
          No articles found related to "{{ lastSearchKeyword }}".
          <button class="reset-search-btn" @click="resetSearch">Clear search results</button>
        </div>
      </div>
    </div>

    <!-- Most popular articles area -->
    <div class="popular-articles-section">
      <div class="container">
        <h2 class="section-title">Most Popular Articles</h2>
        
        <div v-if="loadingPopular" class="loading-spinner">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
        
        <div v-else-if="errorPopular" class="alert alert-danger">
          {{ errorPopular }}
        </div>
        
        <div v-else-if="popularArticles.length === 0" class="no-articles">
          No popular articles available
        </div>
        
        <div v-else class="swiper-container">
          <div class="swiper-button-prev custom-nav-prev popular-nav-prev"></div>
          <swiper
            :modules="swiperModules"
            :slides-per-view="3"
            :space-between="20"
            :navigation="{
              nextEl: '.popular-nav-next',
              prevEl: '.popular-nav-prev'
            }"
            :pagination="{ 
              clickable: true,
              el: '.popular-pagination'
            }"
            :breakpoints="swiperBreakpoints"
            class="article-slider"
          >
            <swiper-slide v-for="article in popularArticles" :key="'popular-' + article.id">
              <article-card :article="article" :show-views="true" />
            </swiper-slide>
          </swiper>
          <div class="swiper-button-next custom-nav-next popular-nav-next"></div>
          <div class="swiper-pagination popular-pagination"></div>
        </div>
      </div>
    </div>

    <!-- Articles list area -->
    <div class="articles-section">
      <div class="container">
        <h2 class="section-title">{{ isSearchResult ? 'All Article Resources' : 'Article Resources' }}</h2>
        
        <div v-if="loading" class="loading-spinner">
          <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
          </div>
        </div>
        
        <div v-else-if="error" class="alert alert-danger">
          {{ error }}
        </div>
        
        <div v-else class="swiper-container">
          <div class="swiper-button-prev custom-nav-prev main-nav-prev"></div>
          <swiper
            :modules="swiperModules"
            :slides-per-view="3"
            :space-between="20"
            :navigation="{
              nextEl: '.main-nav-next',
              prevEl: '.main-nav-prev'
            }"
            :pagination="{ 
              clickable: true,
              el: '.main-pagination'
            }"
            :breakpoints="swiperBreakpoints"
            class="article-slider"
          >
            <swiper-slide v-for="article in articles" :key="article.id">
              <article-card :article="article" />
            </swiper-slide>
          </swiper>
          <div class="swiper-button-next custom-nav-next main-nav-next"></div>
          <div class="swiper-pagination main-pagination"></div>
        </div>
      </div>
    </div>
    <MyFooter />
  </div>
</template>

<script>
import { Swiper, SwiperSlide } from 'swiper/vue';
import { Navigation, Pagination } from 'swiper/modules';
import 'swiper/css';
import 'swiper/css/navigation';
import 'swiper/css/pagination';
import MyFooter from '../components/test/MyFooter.vue';
import MyNavBar from '../components/test/MyNavBar.vue';
import ArticleCard from '@/components/ArticleCard.vue';
import apiService from '@/services/api';

export default {
  name: 'resource',
  components: {
    Swiper,
    SwiperSlide,
    ArticleCard,
    MyFooter,
    MyNavBar
  },
  data() {
    return {
      articles: [],        // All articles
      popularArticles: [], // Popular articles
      searchResults: [],   // Search results
      loading: true,       // Initial loading state
      loadingPopular: true,// Popular articles loading state
      error: null,         // Initial loading error
      errorPopular: null,  // Popular articles loading error
      loadingSearch: false,// Search loading state
      errorSearch: null,   // Search error
      searchKeyword: '',
      isSearchResult: false, // Whether search has been executed
      lastSearchKeyword: '', // Last searched keyword
      // 提取常用配置到数据属性
      swiperModules: [Navigation, Pagination],
      swiperBreakpoints: {
        320: { slidesPerView: 1, spaceBetween: 10 },
        640: { slidesPerView: 2, spaceBetween: 15 },
        992: { slidesPerView: 3, spaceBetween: 20 }
      }
    };
  },
  created() {
    this.fetchArticles();
    this.fetchPopularArticles();
  },
  methods: {
    async fetchArticles() {
      this.loading = true;
      this.error = null; 
      try {
        const response = await apiService.getArticles();
        this.articles = response.data.data;
      } catch (err) {
        this.error = 'Unable to load articles: ' + (err.message || err);
        console.error('Article loading error:', err);
      } finally {
        this.loading = false;
      }
    },
    
    async fetchPopularArticles() {
      this.loadingPopular = true;
      this.errorPopular = null;
      try {
        const response = await apiService.getPopularArticles(5); // Get top 5 popular articles
        this.popularArticles = response.data.data;
      } catch (err) {
        this.errorPopular = 'Unable to load popular articles: ' + (err.message || err);
        console.error('Popular articles loading error:', err);
      } finally {
        this.loadingPopular = false;
      }
    },
    
    async searchArticles() {
      if (!this.searchKeyword.trim()) {
        this.resetSearch(); 
        return;
      }
      
      this.loadingSearch = true;
      this.errorSearch = null;
      this.isSearchResult = true;
      this.lastSearchKeyword = this.searchKeyword;
      this.searchResults = [];

      try {
        const response = await apiService.searchArticles(this.searchKeyword);
        this.searchResults = response.data.data;
      } catch (err) {
        this.errorSearch = 'Error during search: ' + (err.message || err);
        console.error('Search error:', err);
      } finally {
        this.loadingSearch = false;
      }
    },
    
    resetSearch() {
      this.isSearchResult = false;
      this.lastSearchKeyword = '';
      this.searchResults = [];
      this.errorSearch = null;
      this.loadingSearch = false;
    }
  }
}
</script>

<style scoped>
/* Overall page style */
.resource-page {
  width: 100%;
  font-family: Arial, sans-serif;
}

/* Top banner style */
.hero-banner {
  background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('/images/hero-banner.jpg');
  background-size: cover;
  background-position: center;
  color: white;
  padding: 80px 20px;
  text-align: center;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.hero-title {
  font-size: 2.5rem;
  font-weight: bold;
  margin-bottom: 1rem;
}

.hero-subtitle {
  font-size: 1.1rem;
  line-height: 1.5;
  max-width: 600px;
  margin: 0 auto;
}

/* Search area style */
.search-container {
  background-color: #f5f5f0;
  padding: 40px 20px;
}

.search-wrapper {
  max-width: 800px;
  margin: 0 auto;
}

.search-heading {
  text-align: center;
  color: #4a90e2;
  font-size: 1.2rem;
  margin-bottom: 30px;
}

.keyword-search {
  margin-top: 20px;
}

.keyword-search label {
  display: block;
  margin-bottom: 8px;
  font-size: 0.9rem;
  text-align: center;
}

.form-control {
  width: 100%;
  padding: 10px 15px;
  border: 1px solid #ddd;
  border-radius: 4px;
  margin-bottom: 15px;
}

.search-button {
  display: block;
  width: 100%;
  max-width: 200px;
  margin: 0 auto;
  padding: 10px;
  background-color: #d83cad;
  color: white;
  border: none;
  border-radius: 20px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s;
}

.search-button:hover {
  background-color: #c02e96;
}

/* Search results area style */
.search-results-section {
  padding: 40px 20px;
  background-color: #f0f7ff;
  margin-bottom: 30px;
}

/* Search results info general style */
.search-result-info {
  text-align: center;
  margin-bottom: 20px;
  padding: 10px;
  background-color: #fff;
  border: 1px solid #d1e3ff; 
  border-radius: 4px;
  font-size: 0.9rem;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
}

/* Most popular articles area style */
.popular-articles-section {
  padding: 40px 20px;
  background-color: #f9f4ff;
  margin-bottom: 30px;
}

.popular-articles-section .article-card {
  position: relative;
}

.popular-articles-section .article-card::before {
  content: "Popular";
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: #e74c3c;
  color: white;
  padding: 3px 8px;
  border-radius: 4px;
  font-size: 0.7rem;
  z-index: 1;
}

/* 共享样式 */
.container {
  max-width: 1200px;
  margin: 0 auto;
}

.section-title {
  text-align: center;
  margin-bottom: 40px;
  font-size: 2rem;
  color: #333;
}

.loading-spinner {
  display: flex;
  justify-content: center;
  padding: 40px;
}

.alert-danger {
  text-align: center;
  padding: 15px;
  margin-bottom: 20px;
  border-radius: 4px;
  color: #721c24;
  background-color: #f8d7da;
  border: 1px solid #f5c6cb;
}

/* 空内容提示 */
.no-articles {
  text-align: center;
  padding: 30px;
  background-color: #f9f9f9;
  border-radius: 4px;
  color: #666;
  font-style: italic;
}

/* 重置按钮样式 */
.reset-search-btn {
  background: none;
  border: none;
  color: #4a90e2;
  text-decoration: underline;
  cursor: pointer;
  margin-left: 10px;
  font-size: 0.9rem;
}

.reset-search-btn:hover {
  color: #2a70c2;
}

/* 文章列表区域样式 */
.articles-section {
  padding: 60px 20px;
}

/* Swiper相关样式 */
.swiper-container {
  position: relative;
  padding: 0 50px;
  margin-bottom: 60px;
}

.article-slider {
  padding-bottom: 40px;
}

/* 自定义导航箭头 */
.custom-nav-prev,
.custom-nav-next {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 40px;
  height: 40px;
  background-color: #fff;
  border-radius: 50%;
  box-shadow: 0 2px 5px rgba(0,0,0,0.15);
  z-index: 10;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.custom-nav-prev {
  left: 0;
}

.custom-nav-next {
  right: 0;
}

.custom-nav-prev::after,
.custom-nav-next::after {
  font-size: 20px;
  color: #4a90e2;
}

/* 分页样式 */
:deep(.swiper-pagination) {
  position: absolute;
  bottom: -10px !important;
  left: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  padding: 10px 0;
}

:deep(.swiper-pagination-bullet) {
  width: 10px;
  height: 10px;
  margin: 0 5px;
  background-color: #ccc;
  opacity: 1;
}

:deep(.swiper-pagination-bullet-active) {
  background-color: #4a90e2;
}

/* 响应式调整 */
@media (max-width: 768px) {  
  .hero-title {
    font-size: 2rem;
  }
  
  .section-title {
    font-size: 1.5rem;
  }
}
</style>