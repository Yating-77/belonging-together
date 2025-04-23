import { createRouter, createWebHistory } from 'vue-router'
import Homepage from '../views/homepage.vue'
import Recommendation from '../views/recommendation.vue'
import resource from '../views/resource.vue'
import ArticleView from '../views/ArticleView.vue'
import IntroPage from '../views/IntroPage.vue'
import ThankYouPage from '../views/ThankYouPage.vue'; 

// 从环境变量中获取基础路径，默认为'/iteration1/'
// 注意：此值应与vite.config.js中的base值保持一致
const baseUrl = import.meta.env.BASE_URL || '/iteration1/';
console.log(`Router using base URL: ${baseUrl}`);

const routes = [
  {
    path: '/',
    name: 'home',
    component: Homepage
  },
  {
    path: '/recommendation',
    name: 'recommendation',
    component: Recommendation
  },
  {
    path:'/resource',
    name:'resource',
    component: resource
  },
  {
    path: '/article/:id',
    name: 'article',
    component: ArticleView
  },
  {
    path: '/intro',
    name: 'intro',
    component: IntroPage
  },
  {
    path: '/thank-you',
    name: 'ThankYou',
    component: ThankYouPage
  }
]

const router = createRouter({
  history: createWebHistory(baseUrl),
  routes,
  scrollBehavior(to, from, savedPosition) {
    return { top: 0 }
  }
})

export default router