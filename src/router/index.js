import { createRouter, createWebHistory } from 'vue-router'
import Homepage from '../views/homepage.vue'
import Recommendation from '../views/recommendation.vue'
import resource from '../views/resource.vue'
import ArticleView from '../views/ArticleView.vue'
import IntroPage from '../views/IntroPage.vue'
import venuePage from '../views/venuePage.vue'
import detectpage from '@/views/detectpage.vue'
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
    path: '/venue',
    name: 'venue',
    component: venuePage
  },
  {
    path: '/detectpage', // 定义 Thank You 页面的路径
    name: 'detectpage',
    component: detectpage// 使用新创建的组件
  },
]

const router = createRouter({
  history: createWebHistory('/iteration1'),
  routes,
  scrollBehavior(to, from, savedPosition) {
    return { top: 0 }
  }
})

export default router