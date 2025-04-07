import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:3000/api',
  headers: {
    'Content-Type': 'application/json'
  }
})

export default {
  // 获取所有文章列表
  getArticles() {
    return apiClient.get('/articles')
  },
  
  // 获取单篇文章详情
  getArticle(id) {
    return apiClient.get(`/articles/${id}`)
  },
  
  // 搜索文章 - 使用正确的搜索路由
  searchArticles(keyword) {
    // 确保使用完整的路径，包括/api前缀
    return apiClient.get(`/test-search?keyword=${encodeURIComponent(keyword)}`);
    
    // 当主搜索路由修复后，可以切换到这个:
    // return apiClient.get(`/articles/search?keyword=${encodeURIComponent(keyword)}`);
  },
  getPopularArticles(limit = 5) {
    return apiClient.get(`/articles/popular?limit=${limit}`);
  },
  
  incrementArticleViewCount(id) {
    return apiClient.post(`/articles/${id}/view`);
  }
}