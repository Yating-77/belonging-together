import axios from 'axios';

const apiClient = axios.create({
  baseURL: 'http://localhost:3000/api',
  headers: {
    'Content-Type': 'application/json'
  }
});

const api = {
  // Articles
  getArticles() {
    return apiClient.get('/articles');
  },
  getArticle(id) {
    return apiClient.get(`/articles/${id}`);
  },
  searchArticles(keyword) {
    return apiClient.get(`/articles/search?keyword=${encodeURIComponent(keyword)}`);
  },
  getPopularArticles(limit = 4) {
    return apiClient.get(`/articles/popular?limit=${limit}`);
  },
  incrementArticleViewCount(id) {
    return apiClient.post(`/articles/${id}/view`);
  },

  // Recommendations
  getCategories() {
    return apiClient.get('/categories');
  },
  getQuestions(categoryId) {
    return apiClient.get(`/questions/${categoryId}`);
  },
  getOptions(categoryId) {
    return apiClient.get(`/options/${categoryId}`);
  },
  getRecommendations(optionId) {
    return apiClient.get(`/recommendations/${optionId}`);
  },

  // Charts
  getPrevalenceTrends() {
    return apiClient.get('/charts/prevalence-trends');
  },
  getGenderAgePrevalence() {
    return apiClient.get('/charts/gender-age-prevalence');
  },
  getBehavioralDifficulties() {
    return apiClient.get('/charts/behavioral-difficulties');
  }
};

export default api;
