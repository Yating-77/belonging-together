import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:3000/api',
  headers: {
    'Content-Type': 'application/json'
  }
})

export default {
  getArticles() {
    return apiClient.get('/articles')
  },
  
  getArticle(id) {
    return apiClient.get(`/articles/${id}`)
  },
  
  searchArticles(keyword) {
    return apiClient.get(`/test-search?keyword=${encodeURIComponent(keyword)}`);
  },
  getPopularArticles(limit = 5) {
    return apiClient.get(`/articles/popular?limit=${limit}`);
  },
  
  incrementArticleViewCount(id) {
    return apiClient.post(`/articles/${id}/view`);
  }
}