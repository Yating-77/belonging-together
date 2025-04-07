<template>
  <div class="article-page-wrapper">
    <div class="article-container">
      <button class="back-button" @click="goBack">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-left"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
        <span>Back to Article List</span>
      </button>

      <div v-if="loading" class="status-indicator loading">
        <div class="spinner"></div>
        Loading article...
      </div>

      <div v-else-if="error" class="status-indicator error">
        <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-alert-triangle"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
        <span>Failed to load article: {{ error }}</span>
      </div>

      <article v-else class="article-content">
        <header class="article-header">
          <h1 class="article-title">{{ article.title }}</h1>
          <div class="article-meta">
            <span class="article-date">
              <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-calendar"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
              {{ formatDate(article.created_at) }}
            </span>
            <span v-if="article.view_count" class="article-views">
              <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-eye"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
              {{ article.view_count }} views
            </span>
          </div>
        </header>

        <!-- Use v-html to render HTML content -->
        <div class="article-body" v-html="formattedContent"></div>

      </article>
    </div>
  </div>
</template>

<script>
import apiService from '@/services/api'
// import marked from 'marked'; // Uncomment if using Markdown

export default {
  name: 'ArticleView',
  data() {
    return {
      article: {},
      loading: true,
      error: null
    }
  },
  computed: {
    formattedContent() {
      if (!this.article.content) return '';
      // If HTML, return directly
      return this.article.content;
      // If Markdown, uncomment the next line and ensure marked is installed and imported
      // return marked(this.article.content);
    }
  },
  created() {
    this.fetchArticle()
  },
  methods: {
    async fetchArticle() {
      const articleId = this.$route.params.id
      this.loading = true
      this.error = null // Reset error on new fetch
      try {
        const response = await apiService.getArticle(articleId)
        this.article = response.data.data

        // Increment view count silently (don't wait for it to finish to show content)
        apiService.incrementArticleViewCount(articleId).catch(err => {
          console.warn('Failed to increment view count:', err);
          // Optionally handle this error, but it shouldn't block the user
        });

      } catch (err) {
        this.error = 'Unable to load article content' // More user-friendly error
        console.error('Failed to get article:', err.response?.data?.message || err.message || err)
      } finally {
        this.loading = false
      }
    },
    formatDate(dateString) {
      if (!dateString) return '';
      try {
          const date = new Date(dateString)
          // Use a slightly more common format
          return date.toLocaleDateString('en-US', {
              year: 'numeric',
              month: '2-digit',
              day: '2-digit'
          }) + ' ' + date.toLocaleTimeString('en-US', {
              hour: '2-digit',
              minute: '2-digit',
              hour12: false
          });
      } catch (e) {
          console.error("Error formatting date:", e);
          return dateString; // Return original string if formatting fails
      }
    },
    goBack() {
      // More robust back navigation: goes back in history if possible, otherwise to /resource
      if (window.history.length > 1) {
        this.$router.go(-1);
      } else {
        this.$router.push('/resource');
      }
    }
  }
}
</script>

<style scoped>
/* Use a more modern font stack */
:root {
  --primary-color: #007bff; /* Example blue */
  --text-color: #343a40;
  --secondary-text-color: #6c757d;
  --light-gray: #f8f9fa;
  --border-color: #dee2e6;
  --error-color: #dc3545;
  --container-max-width: 840px;
  --border-radius: 8px;
  --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* Overall page wrapper for background */
.article-page-wrapper {
  background-color: var(--light-gray);
  padding: 40px 20px;
  min-height: 100vh; /* Ensure background covers viewport */
}

.article-container {
  max-width: var(--container-max-width);
  margin: 0 auto;
  background-color: #fff;
  padding: 30px 40px; /* Increased padding */
  border-radius: var(--border-radius);
  box-shadow: var(--box-shadow);
  transition: box-shadow 0.3s ease-in-out;
}
.article-container:hover {
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
}

.back-button {
  display: inline-flex; /* Align icon and text */
  align-items: center;
  gap: 8px; /* Space between icon and text */
  background: none;
  border: none;
  color: var(--primary-color);
  cursor: pointer;
  font-size: 16px;
  padding: 8px 0; /* More clickable area */
  margin-bottom: 30px;
  font-weight: 500;
  transition: color 0.2s ease;
}

.back-button svg {
  width: 1.2em;
  height: 1.2em;
}

.back-button:hover {
  color: #0056b3; /* Darker blue on hover */
  text-decoration: none; /* Remove default underline */
}
.back-button:hover span {
    text-decoration: underline;
}


/* Loading and Error States */
.status-indicator {
  text-align: center;
  padding: 60px 20px;
  font-size: 1.1em;
  color: var(--secondary-text-color);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
}

.status-indicator.error {
  color: var(--error-color);
}
.status-indicator.error svg {
    width: 2em;
    height: 2em;
    stroke: var(--error-color);
}


/* Simple CSS Spinner */
.spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border-left-color: var(--primary-color);
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Article Header */
.article-header {
    margin-bottom: 40px;
    padding-bottom: 20px;
    border-bottom: 1px solid var(--border-color);
}

.article-title {
  font-size: 2.5em; /* Larger title */
  margin-bottom: 15px;
  color: var(--text-color);
  font-weight: 700; /* Bolder title */
  line-height: 1.3;
}

.article-meta {
  color: var(--secondary-text-color);
  display: flex;
  flex-wrap: wrap; /* Allow wrapping on small screens */
  align-items: center;
  gap: 10px 25px; /* Row and column gap */
  font-size: 0.95em;
}

.article-meta span {
  display: inline-flex;
  align-items: center;
  gap: 6px; /* Space between icon and text in meta */
}

.article-meta svg {
  width: 1.1em;
  height: 1.1em;
  stroke-width: 1.8; /* Slightly thinner icons */
  color: #999; /* Subtle icon color */
}


/* Article Body Styling */
.article-body {
  font-size: 1.05em; /* Slightly larger base font size */
  line-height: 1.8; /* Increased line height for readability */
  color: var(--text-color);
}

/* Styling for elements INSIDE v-html */
.article-body :deep(h1),
.article-body :deep(h2),
.article-body :deep(h3),
.article-body :deep(h4),
.article-body :deep(h5),
.article-body :deep(h6) {
  margin-top: 2em;
  margin-bottom: 1em;
  font-weight: 600;
  line-height: 1.4;
  color: #222; /* Slightly darker headings */
}
.article-body :deep(h2) { font-size: 1.8em; border-bottom: 1px solid var(--border-color); padding-bottom: 0.3em; }
.article-body :deep(h3) { font-size: 1.5em; }
.article-body :deep(h4) { font-size: 1.2em; }

.article-body :deep(p) {
  margin-bottom: 1.5em;
}

.article-body :deep(ul),
.article-body :deep(ol) {
  margin-bottom: 1.5em;
  padding-left: 25px;
}
.article-body :deep(li) {
    margin-bottom: 0.5em;
}

.article-body :deep(a) {
  color: var(--primary-color);
  text-decoration: none;
  transition: color 0.2s ease, border-bottom 0.2s ease;
  border-bottom: 1px solid transparent;
}

.article-body :deep(a:hover) {
  color: #0056b3;
  border-bottom-color: #0056b3;
}

.article-body :deep(img) {
  max-width: 100%;
  height: auto;
  display: block; /* Remove extra space below image */
  margin: 30px auto; /* Center images and add vertical space */
  border-radius: var(--border-radius); /* Optional: rounded corners for images */
  box-shadow: 0 2px 8px rgba(0,0,0,0.1); /* Subtle shadow for images */
}

.article-body :deep(blockquote) {
  margin: 2em 0;
  padding: 15px 20px;
  border-left: 4px solid var(--primary-color);
  background-color: var(--light-gray);
  color: var(--secondary-text-color);
  font-style: italic;
  border-radius: 0 var(--border-radius) var(--border-radius) 0;
}
.article-body :deep(blockquote p:last-child) {
    margin-bottom: 0; /* Remove extra margin inside blockquote */
}

/* Basic Code Block Styling (Consider a syntax highlighter like Prism.js for better results) */
.article-body :deep(pre) {
  background-color: #2d2d2d; /* Dark background for code */
  color: #f8f8f2; /* Light text for code */
  padding: 20px;
  border-radius: var(--border-radius);
  overflow-x: auto; /* Allow horizontal scrolling for long lines */
  margin: 2em 0;
  font-family: 'Fira Code', Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace; /* Monospace font stack */
  font-size: 0.9em;
  line-height: 1.5;
}

.article-body :deep(code) {
  font-family: 'Fira Code', Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace;
}

/* Inline code */
.article-body :deep(:not(pre) > code) {
  background-color: rgba(0, 123, 255, 0.08); /* Subtle background */
  color: #333;
  padding: 0.2em 0.4em;
  border-radius: 4px;
  font-size: 0.9em;
}

/* Add horizontal rule styling */
.article-body :deep(hr) {
    border: none;
    height: 1px;
    background-color: var(--border-color);
    margin: 2.5em 0;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
  .article-container {
    padding: 20px;
  }
  .article-title {
    font-size: 2em;
  }
  .article-body {
    font-size: 1em;
    line-height: 1.7;
  }
  .article-body :deep(h2) { font-size: 1.6em; }
  .article-body :deep(h3) { font-size: 1.3em; }
}
</style>