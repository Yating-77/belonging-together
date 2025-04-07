import { createRouter, createWebHistory } from 'vue-router'
import Homepage from '../views/homepage.vue'
import Recommendation from '../views/recommendation.vue'
import resource from '../views/resource.vue'
import ArticleView from '../views/ArticleView.vue'
//import { path } from 'animejs'

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
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior(to, from, savedPosition) {
    // 总是滚动到顶部
    return { top: 0 }
  }
})

export default router