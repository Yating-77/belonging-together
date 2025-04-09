<template>
  <div class="article-view">
    <MyNavBar />
    <main>
      <div class="back-button-container">
        <button @click="goBack" class="back-button">
          <i class="fas fa-arrow-left"></i> Back to Article List
      </button>
      </div>

      <div v-if="loading" class="loading-container">
        <div class="spinner"></div>
        <p>Loading article...</p>
      </div>

      <div v-else-if="error" class="error-container">
        <i class="fas fa-exclamation-triangle"></i>
        <p>{{ error }}</p>
      </div>

      <div v-else>
        <div class="centered-image-container">
          <img 
            :src="articleImageUrl" 
            :alt="article.title" 
            class="centered-article-image"
            @error="handleImageError"
          />
        </div>
        
        
        <div class="colored-content-container">
          <div class="article-content">
          <h1 class="article-title">{{ article.title }}</h1>
           
            <div class="article-meta" v-if="article.view_count">
              <span class="views">
                <i class="far fa-eye"></i> {{ article.view_count }} views
            </span>
          </div>

        <div class="article-body" v-html="formattedContent"></div>
            <div class="article-source" v-if="article.source_link">
              <hr />
              <p>
                <strong>Source: </strong>
                <a :href="article.source_link" target="_blank" rel="noopener noreferrer">
                  {{ article.source_link }}
                </a>
              </p>
            </div>
          </div>
        </div>
    </div>
    </main>
    
    <MyFooter />
  </div>
</template>

<script>
import apiService from '@/services/api'
import MyNavBar from '../components/test/MyNavBar.vue'
import MyFooter from '../components/test/MyFooter.vue'

export default {
  name: 'ArticleView',
  components: {
    MyNavBar,
    MyFooter
  },
  data() {
    return {
      article: {},
      loading: true,
      error: null,
      imageError: false
    }
  },
  computed: {
    formattedContent() {
      if (!this.article.content) return '';

      return this.article.content
        .replace(/\\n\\n/g, '\n\n')
        .split(/\n{2,}/) 
        .map(p => `<p>${p.trim()}</p>`)
        .join('');
    },
    articleImageUrl() {
      if (this.imageError) {
        return '/images/fallback-image.jpg'; 
      }
   
      if (this.article.image_path) {
        return this.article.image_path;
      }
      
     
      return `http://belongingtogether.me/image/article_${this.article.id}.jpg`;
    }
  },
  created() {
    this.fetchArticle();
  },
  methods: {
    async fetchArticle() {
      const articleId = this.$route.params.id;
      this.loading = true;
      this.error = null;
      
      try {
        const response = await apiService.getArticle(articleId);
        this.article = response.data.data;
        
        apiService.incrementArticleViewCount(articleId).catch(err => {
          console.warn('Failed to increment view count:', err);
        });
      } catch (err) {
        this.error = 'Unable to load article content';
        console.error('Failed to get article:', err.response?.data?.message || err.message || err);
      } finally {
        this.loading = false;
      }
    },
    goBack() {
      if (window.history.length > 1) {
        this.$router.go(-1);
      } else {
        this.$router.push('/resource');
      }
    },
    handleImageError() {
      this.imageError = true;
    }
  }
}
</script>

<style scoped>

.article-view {
  max-width: 100%;
  min-height: 100vh;
  background-color: #f5f5f5;
  display: flex;
  flex-direction: column;
}

main {
  flex: 1;
}


.back-button-container {
  padding: 15px;
  max-width: 786px;
  margin: 0 auto;
  width: 100%;
}

.back-button {
  background: none;
  border: none;
  color: #4d7234;
  font-size: 16px;
  cursor: pointer;
  padding: 8px 16px;
  display: flex;
  align-items: center;
  gap: 8px;
  border-radius: 4px;
  transition: background-color 0.2s;
}

.back-button:hover {
  background-color: rgba(0, 255, 72, 0.08);
}


.loading-container, .error-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 50px 20px;
  text-align: center;
  gap: 15px;
}

.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border-left-color: #007bff;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-container {
  color: #dc3545;
}

.error-container i {
  font-size: 36px;
}


.centered-image-container {
  display: flex;
  justify-content: center;
  width: 100%;
  background-color: #f5f5f5;
  padding: 20px 0;
}

.centered-article-image {
  max-width: 786px;
  width: 100%;
  height: auto;
  display: block;
}


.colored-content-container {
  background-color: #f9f9f9;
  padding: 40px 20px;
}

.article-content {
  max-width: 786px;
  margin: 0 auto;
  background-color: #fff;
  padding: 30px;
  border-radius: 4px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.05);
}

.article-title {
  font-size: 1.8rem;
  margin: 0 0 20px 0;
  color: #333;
  line-height: 1.3;
  font-weight: 600;
}

.article-meta {
  display: flex;
  gap: 20px;
  margin-bottom: 25px;
  font-size: 0.9rem;
  color: #666;
}

.article-meta i {
  margin-right: 5px;
}


.article-body {
  line-height: 1.8;
  font-size: 1.05rem;
  color: #000;
}


.article-body :deep(h1),
.article-body :deep(h2),
.article-body :deep(h3),
.article-body :deep(h4),
.article-body :deep(h5),
.article-body :deep(h6) {
  margin-top: 1.5em;
  margin-bottom: 0.8em;
  font-weight: 600;
  line-height: 1.4;
  color: #222;
}

.article-body :deep(h2) { 
  font-size: 1.8em; 
  border-bottom: 1px solid #eee; 
  padding-bottom: 0.3em; 
}

.article-body :deep(h3) { font-size: 1.5em; }
.article-body :deep(h4) { font-size: 1.2em; }

.article-body :deep(p) {
  margin-bottom: 1.5em;
}

.article-body :deep(a) {
  color: #007bff;
  text-decoration: none;
  border-bottom: 1px solid transparent;
  transition: border-bottom 0.2s;
}

.article-body :deep(a:hover) {
  border-bottom-color: #007bff;
}

.article-body :deep(ul),
.article-body :deep(ol) {
  margin-bottom: 1.5em;
  padding-left: 25px;
}

.article-body :deep(li) {
    margin-bottom: 0.5em;
}

.article-body :deep(img) {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 30px auto;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.article-body :deep(blockquote) {
  margin: 2em 0;
  padding: 15px 20px;
  border-left: 4px solid #007bff;
  background-color: #f8f9fa;
  color: #6c757d;
  font-style: italic;
}

.article-body :deep(pre) {
  background-color: #2d2d2d;
  color: #f8f8f2;
  padding: 20px;
  border-radius: 4px;
  overflow-x: auto;
  margin: 2em 0;
  font-size: 0.9em;
  line-height: 1.5;
}

.article-body :deep(code) {
  font-family: 'Fira Code', Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace;
}

.article-body :deep(:not(pre) > code) {
  background-color: rgba(0, 123, 255, 0.08);
  color: #333;
  padding: 0.2em 0.4em;
  border-radius: 4px;
  font-size: 0.9em;
}


@media (max-width: 768px) {
  .centered-image-container {
    padding: 10px 0;
  }
  
  .article-content {
    padding: 20px;
  }
  
  .article-title {
    font-size: 1.5rem;
  }
  
  .article-body {
    font-size: 1rem;
  }
}
</style>