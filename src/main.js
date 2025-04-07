// src/main.js

import { createApp } from 'vue'
import App from './App.vue' // 你的根组件
import ElementPlus from 'element-plus' // 你已有的 Element Plus
import 'element-plus/dist/index.css' // Element Plus 样式
import router from './router' // 你已有的 router 配置

// --- 新增：引入 Font Awesome 相关 (如果你在 IconCardsSection.vue 中使用了 Font Awesome 图标) ---
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
// 下面这行需要包含你在 IconCardsSection.vue 里实际用到的所有图标
import { faBalanceScale, faLink, faClock, faAppleAlt } from '@fortawesome/free-solid-svg-icons'
// --- 新增结束 ---

// --- 新增：引入我们创建的自定义滚动动画指令 ---
import scrollSlideDirective from './directives/scrollSlide' // 确保这个路径是正确的！
// --- 新增结束 ---

// 创建 Vue 应用实例 (你已有)
const app = createApp(App)

// --- 新增：将 Font Awesome 图标添加到库中 (如果使用 Font Awesome) ---
// 这样你才能在组件中使用这些图标
library.add(faBalanceScale, faLink, faClock, faAppleAlt) // 只添加你用到的图标
// --- 新增结束 ---

// --- 新增：全局注册 Font Awesome 组件 (如果使用 Font Awesome) ---
// 这样你就可以在任何组件的模板中使用 <font-awesome-icon> 标签了
app.component('font-awesome-icon', FontAwesomeIcon)
// --- 新增结束 ---

// --- 新增：全局注册自定义滚动指令 ---
// 'scroll-slide' 是指令的名字，在模板中使用时写作 v-scroll-slide
app.directive('scroll-slide', scrollSlideDirective)
// --- 新增结束 ---

// 使用 Element Plus (你已有)
app.use(ElementPlus)
// 使用路由 (你已有)
app.use(router)

// 挂载应用 (你已有)
app.mount('#app')

// --- 重要提醒 ---
// 1. 确保你已经创建了 `./directives/scrollSlide.js` 文件，并且里面的代码是正确的。
// 2. 如果你没有在 `IconCardsSection.vue` 组件中使用 Font Awesome 图标 (比如你用了图片)，
//    那么所有标记为 "新增：引入 Font Awesome 相关"、"新增：将 Font Awesome 图标添加到库中" 和
//    "新增：全局注册 Font Awesome 组件" 的部分都可以删除，并且不需要安装 Font Awesome 的 npm 包。
// 3. 确保滚动动画需要的 CSS 类（`.animate-on-scroll`, `.slide-in-left`, `.slide-in-right`, `.is-visible`）
//    已经被全局加载了。你可以把它们放在 `App.vue` 的 <style> 标签里（不加 scoped），
//    或者放在一个全局的 CSS 文件里（比如你可能已经有的 `./style.css` 或其他被加载的 CSS 文件）。