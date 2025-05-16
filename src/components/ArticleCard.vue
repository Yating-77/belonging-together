<template>
  <div class="article-card" @click="viewArticle">
    <div class="card h-100">
      <img 
        :src="articleImageUrl" 
        class="card-img-top" 
        :alt="article.title"
        @error="handleImageError"
      />
      <div class="card-body d-flex flex-column">
        <h5 class="card-title text-truncate" :title="article.title">{{ article.title }}</h5>
        
        <p v-if="showViews && article.view_count !== undefined" class="view-count">
          <i class="fas fa-eye"></i>
          {{ article.view_count }} {{ article.view_count === 1 ? 'view' : 'views' }}
        </p>

        
        <p class="card-text flex-grow-1">{{ articlePreview }}</p>
        <div class="read-now-btn">
          <button class="btn btn-link p-0">Read Now</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ArticleCard',
  props: {
    article: {
      type: Object,
      required: true
    },
    showViews: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      imageError: false
    };
  },
  computed: {
    articlePreview() {
      if (!this.article.content) return '';
      const textContent = this.article.content.replace(/<[^>]*>/g, '');
      return textContent.substring(0, 60) + (textContent.length > 60 ? '...' : '');
    },
    articleImageUrl() {
      if (this.imageError) {
        return '/path/to/fallback-image.jpg'; // Fallback image path
      }
      
      // If article has an image_url property, use it directly
      if (this.article.image_url) {
        return this.article.image_url;
      }
      
      // Otherwise, construct URL based on article ID
      return `http://localhost:3000/image/article_${this.article.id}.jpg`;
    }
  },
  methods: {
    viewArticle() {
      this.$router.push({ name: 'article', params: { id: this.article.id } });
    },
    handleImageError() {
      this.imageError = true;
    }
  }
}
</script>

<style scoped>
.article-card {
  cursor: pointer;
  transition: transform 0.3s;
  height: 100%;
  display: flex;
}

.article-card:hover {
  transform: translateY(-5px);
}

.card {
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  width: 100%;
}

.card-img-top {
  height: 180px;
  object-fit: cover;
  width: 100%;
  background-color: #e9ecef; /* Placeholder color while image loads */
}

.card-title {
  color: #333;
  font-weight: 600;
  margin-top: 0.5rem;
}

.card-subtitle {
  font-size: 0.9rem;
}

.card-text {
  font-size: 0.95rem;
  color: #555;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

.read-now-btn {
  text-align: left;
}

.read-now-btn .btn {
  color: #4d7234;
  font-weight: 500;
  padding: 0;
  text-decoration: none;
}

.read-now-btn .btn:hover {
  text-decoration: underline;
}

.view-count {
  font-size: 0.8rem;
  color: #666;
  margin-bottom: 10px;
  display: flex;
  align-items: center;
}

.view-count i {
  margin-right: 5px;
  color: #4a90e2;
}
</style>